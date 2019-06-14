#!/bin/bash

if [ -z "$1" ]; then
	echo -e "Usage:
		Enable: ./wifi-hotspot.sh <wifi interface> <ssid> <password>
		Disable: ./wifi-hotspot.sh -d"
	exit 1
fi

echo -e "
 __    __ _   ___ _               _                   _   
/ / /\ \ (_) / __(_)   /\  /\___ | |_ ___ _ __   ___ | |_ 
\ \/  \/ / |/ _\ | |  / /_/ / _ \| __/ __| '_ \ / _ \| __|
 \  /\  /| / /   | | / __  / (_) | |_\__ \ |_) | (_) | |_ 
  \/  \/ |_\/    |_| \/ /_/ \___/ \__|___/ .__/ \___/ \__|
                                         |_|              
"

if [ "$1" = "-d" ]; then
	echo "Disabling hotspot..."
	sudo nmcli radio wwan off
	exit 0
fi

echo "SSID: $2"
echo "Password: $3"
echo -n "Are you sure? [Y/N]: "
read choice

if [ "$choice" = "Y" ] || [ "$choice" = "y" ]; then
	echo "Enabling hotspot $2..."
	sudo nmcli dev wifi hotspot ifname $1 ssid $2 password $3
else
	echo "Quiting..."
	exit 0
fi
