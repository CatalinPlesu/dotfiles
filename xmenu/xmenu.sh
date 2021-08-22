#!/bin/sh

xmenu <<EOF | sh &
Applications
	IMG:./icons/web.png	Web Browser	firefox
	IMG:./icons/gimp.png	Image editor	gimp
Development
	VScodium	vscodium
Terminal (kitty)	kitty
Terminal (st)		st

Shutdown		poweroff
Reboot			reboot
EOF
