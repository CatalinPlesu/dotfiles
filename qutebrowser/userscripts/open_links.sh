#!/bin/sh
file="/home/$(whoami)/.config/qutebrowser/bookmarks/artists"
qutebrowser `cat $file | rofi -dmenu` --target tab-silent 
