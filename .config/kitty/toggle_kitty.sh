#!/bin/sh
if  grep dark ~/.config/kitty/colors.conf 
then
	cp ~/.config/kitty/gruvbox/light.conf ~/.config/kitty/colors.conf
else
	cp ~/.config/kitty/gruvbox/dark.conf ~/.config/kitty/colors.conf
fi
pkill -USR1 -x kitty
