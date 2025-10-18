#!/bin/bash
# background_changer.sh
# A simple Bash script that changes your GNOME background every 30 seconds.
# Author: purplefries1
# License: MIT

# Select the wallpaper directory
# If zenity is installed on your machine
if [ -x "$(command -v zenity)" ]; then
	echo "Please choose the directory where your wallpapers are stored";
	dir=$(zenity --file-selection --directory --title="Please choose the directory");
else
	read -pr "Please enter the directory where your wallpapers are stored: " dir;
fi

# checks
if ! [ -d "$dir" ]; then
	echo "This directory doesn't exist: $dir";
	sleep 2;
	exit 1;
fi
	
if ! [ -r "$dir" ]; then 
	echo "You don't have read permission on $dir . Please choose another directory.";
	sleep 2;
	exit 1;
fi

if ! [ -x "$(command -v gsettings)" ]; then
	echo "Sorry, this script only works on gnome-like environments";
	sleep 2;
	exit 1;
fi








# Script to change background every minute
FOLDER="$dir"
CLOCK=30s

# put all background file names into bg_array
mapfile -t bg_array < <( find "$FOLDER" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" \) )

# the number of wallpapers we have
wallpaper_size=${#bg_array[@]}

if [ $wallpaper_size -eq 0 ]; then
    echo "No wallpapers found in $FOLDER"
    sleep 2
    exit 1
fi

while true; do
	wallpaper_choice=$(($RANDOM %$wallpaper_size))
	
	path="${bg_array[$wallpaper_choice]}"
	uri="file://$path"

	
	gsettings set org.gnome.desktop.background picture-uri "$uri"
	gsettings set org.gnome.desktop.background picture-uri-dark "$uri"
	
	sleep "$CLOCK"
	
done
