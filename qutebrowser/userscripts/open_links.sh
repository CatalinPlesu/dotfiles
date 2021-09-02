#!/bin/sh
file="/home/$(whoami)/.config/qutebrowser/bookmarks/artists"
url=`cat $file | rofi -dmenu`
echo "open -t $url" >> "$QUTE_FIFO"
