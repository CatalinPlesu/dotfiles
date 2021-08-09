#!/bin/bash
file='/home/catalin/.config/qutebrowser/artists'
out='/home/catalin/.config/qutebrowser/modules/page.py'
echo "from random import randrange" > $out
echo "def startpage():" >> $out
echo "	pages = [" >> $out
while read line; do
echo "	'$line'," >> $out
done < $file
echo "	]" >> $out
echo "	return pages[randrange(0,len(pages)-2)]" >> $out
echo "print(startpage())" >> $out
