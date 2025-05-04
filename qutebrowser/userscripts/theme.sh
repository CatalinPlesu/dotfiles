#!/bin/sh
ls ~/.config/qutebrowser/themes | wofi -dmenu | xargs -I% sed -i 's/config.source("themes[^ ]*/config.source("themes\/%")/' ~/.config/qutebrowser/config.py  
echo "config-source" >> "$QUTE_FIFO"
