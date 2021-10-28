#!/bin/sh
url=`shuf -n 1 /home/$(whoami)/.config/qutebrowser/bookmarks/artists`  
echo "open -b $url" >> "$QUTE_FIFO"
