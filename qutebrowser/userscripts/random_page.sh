#!/bin/sh
bookmarks_dir="/home/$(whoami)/.config/qutebrowser/bookmarks/"
alias ls='ls --ignore={"urls","artists","3d_assets"}' # blacklist files

if [ -z "$1" ]; then
    cd $bookmarks_dir
    url=$(cat $(ls) | shuf -n 1)
else 
    url=`shuf -n 1 /home/$(whoami)/.config/qutebrowser/bookmarks/$1`  
fi

echo "open -t $url" >> "$QUTE_FIFO"
