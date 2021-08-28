#!/bin/sh
file="/home/$(whoami)/.config/qutebrowser/bookmarks/artists"
echo `xclip -out -selection clipboard ` >> $file
sort -o $file $file
