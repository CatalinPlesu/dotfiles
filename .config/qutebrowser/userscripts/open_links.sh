#!/bin/sh
file='/home/catalin/.config/qutebrowser/artists'
qutebrowser `cat $file | rofi -dmenu` --target tab-bg-silent 
