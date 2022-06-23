#!/bin/bash
# ctrl + alt + space -- capture 
Xephyr -screen 800x600 :80 &
sleep 1

export DISPLAY=:80
sxhkd&
# nitrogen --restore&
./dwm
killall Xephyr
export DISPLAY=:1
