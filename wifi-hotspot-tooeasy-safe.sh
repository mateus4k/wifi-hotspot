#!/bin/bash

ssid=`uname -n`
password="$(perl -MList::Util=shuffle -e '$s="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPARSTUVWXYZ";@a=split(//,$s);$s=undef;@b=shuffle(@a);print join("",@b[0..8])')"
ifname="$(lshw -C Network 2>/dev/null | perl -M-strict=vars -Mwarnings -ne 'BEGIN{$listening=0;$foundit=0;}END{exit 40 unless $foundit == 1;}$line=$_;if($listening==0 && $line =~ /wireless/i){$listening=1;}if($listening == 1 && $line =~ /logical name: ([a-zA-Z0-9_\-]+)/){print $1;$foundit=1;exit 0;}')"

#sanity check
[ -z "$ssid" ] && { echo shit1; exit 4; }
[ -z "$password" ] && { echo shit2; exit 5; }
[ -z "$ifname"  ] && { echo shit3; exit 6; }
[[ "$ifname" =~ ^[a-zA-Z0-9_\-]+$ ]] || { echo shit4; exit 7; }


tmp_script_filename="$(mktemp --suffix='_hotspotd')"
cat <<EOF | tee $tmp_script_filename | sed "s/\($password\|$ssid\)/\x1b[31m\\1\x1b[39m/g"
breakfree=0;ctrlc(){ nmcli connection down uuid \$(nmcli connection show | grep $ifname | awk '{print \$2;exit}');sudo nmcli radio wwan off;breakfree=1;}; sudo nmcli dev wifi hotspot ifname $ifname ssid $ssid password $password; trap ctrlc SIGINT; echo 'CTRL+c to end your wifi hotspot'; while :;do if [ \$breakfree -eq 0 ]; then sleep 1; else break; fi; done
EOF

echo -e "\n\nEasy run with:"
echo bash $tmp_script_filename '#requires that you have sudo for your current user.'
