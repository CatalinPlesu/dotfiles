#!/bin/sh
url=`shuf -n 1 /home/$(whoami)/.config/qutebrowser/bookmarks/artists`  
qutebrowser $url --target tab-bg-silent 
