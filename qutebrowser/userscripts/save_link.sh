#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"
file=$(ls $path | rofi -dmenu -p "save link in")
echo `xclip -out -selection clipboard ` >> $path$file
