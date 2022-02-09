#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"
if [ -z "$1" ]
then
    file=$(ls $path | rofi -dmenu -p "save link in")
else
    file="$1"
fi
echo "$file"
echo `xclip -out -selection clipboard ` >> $path$file
