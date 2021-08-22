#!/bin/sh
file='/home/catalin/.config/qutebrowser/artists'
echo `xclip -out -selection clipboard ` >> $file
sort -o $file $file
