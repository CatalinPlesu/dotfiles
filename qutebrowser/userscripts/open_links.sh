#!/bin/sh
file='/home/catalin/.config/qutebrowser/bookmarks/artists'
qutebrowser `cat $file | rofi -dmenu` --target tab-silent 
