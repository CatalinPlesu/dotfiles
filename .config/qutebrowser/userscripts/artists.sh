#!/bin/bash
file='/home/catalin/.config/qutebrowser/artists'
out='/home/catalin/.config/qutebrowser/startpage.py'
echo "from random import randrange" > $out
echo "startpage = [" >> $out
while read line; do
echo "'$line'," >> $out
done < $file
echo "]" >> $out
echo "c.url.start_pages = [startpage[randrange(0,len(startpage)-2)]]" >> $out
