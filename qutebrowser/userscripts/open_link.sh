#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"

if [ -z "$1" ]
then
    tab=""
else
    tab="-t"
fi

file=$(ls $path | rofi -dmenu -p "open link from")

url=`cat $path$file | rofi -dmenu -p $file`
echo "open $tab $url" >> "$QUTE_FIFO"
