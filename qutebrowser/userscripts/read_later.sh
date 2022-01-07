#!/bin/sh
file="/home/$(whoami)/.config/qutebrowser/bookmarks/read_list"
echo `xclip -out -selection clipboard ` >> $file
# sort -o $file $file
