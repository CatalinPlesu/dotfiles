#!/bin/sh

xmenu <<EOF | sh &
Applications
	Browser	$BROWSER
	File Manager		thunar
	Calculator	galculator
	Image editor	gimp
	Wallpaper	nitrogen
	Torrent		qbittorrent
Development
	VScodium	vscodium
Office
	office	libreoffice
	document	libreoffice --writer
	presentation	libreoffice --impress

IMG:./icons/kitty.png	Terminal			sh -c "cd ~ && $TERMINAL -e tmux"	

Lock			xsecurelock -- xset dpms force off
Shutdown		poweroff
Reboot			reboot
EOF
