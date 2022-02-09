#!/bin/sh
path="/home/$(whoami)/.config/qutebrowser/bookmarks/"
# file=$(ls $path | rofi -dmenu -p "remove link from")
url=$(xclip -out -selection clipboard)
file=$(rg -l "$url" "$path")
sed -i "s|$url||g" "$file"
sed -i '/^[[:space:]]*$/d' "$file"
