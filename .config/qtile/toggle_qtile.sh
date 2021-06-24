#!/bin/sh
if grep dark ~/.config/qtile/theme.py
then
	cp ~/.config/qtile/gruvbox/light.py ~/.config/qtile/theme.py
else
	cp ~/.config/qtile/gruvbox/dark.py ~/.config/qtile/theme.py
fi
qtile cmd-obj -o cmd -f restart

