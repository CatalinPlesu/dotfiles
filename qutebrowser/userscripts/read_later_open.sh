#!/bin/sh
file="/home/$(whoami)/.config/qutebrowser/bookmarks/read_list"
url=`cat $file | rofi -p "read" -dmenu`
echo "open -t $url" >> "$QUTE_FIFO"
