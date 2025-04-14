#!/bin/sh
ls ~/.config/qutebrowser/themes | rofi -dmenu | xargs -I% sed -i 's/config.source("themes[^ ]*/config.source("themes\/%")/' ~/.config/qutebrowser/config.py  
echo "config-source" >> "$QUTE_FIFO"
