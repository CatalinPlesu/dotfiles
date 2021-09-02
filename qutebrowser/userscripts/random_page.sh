#!/bin/sh
url=`shuf -n 1 /home/$(whoami)/.config/qutebrowser/bookmarks/artists`  
echo "open -t $url" >> "$QUTE_FIFO"
