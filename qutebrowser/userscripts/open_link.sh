#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"

if [ -z "$1" ]
then
    tab=""
else
    tab="-t"
fi

file=$(ls $path | rofi -dmenu -p "open link from")

if ! [ -f $file ]; then
    url=`cat $path$file | rofi -dmenu -p $file`
fi

if ! [ -f $url ]; then
    echo "open $tab $url" >> "$QUTE_FIFO"
fi
