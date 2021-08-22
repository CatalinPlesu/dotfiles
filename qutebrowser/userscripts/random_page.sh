#!/bin/sh
url=`shuf -n 1 /home/catalin/.config/qutebrowser/artists`  
qutebrowser $url --target tab-bg-silent 
