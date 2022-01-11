#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"
file=$(ls $path | rofi -dmenu -p "remove link from")
url=$(xclip -out -selection clipboard)
sed -i "s|$url||g" "$path$file"
sed -i '/^[[:space:]]*$/d' "$path$file"


