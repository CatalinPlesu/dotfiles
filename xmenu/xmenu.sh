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
Terminal			$TERMINAL	

Lock			xsecurelock -- xset dpms force off
Shutdown		poweroff
Reboot			reboot
EOF
