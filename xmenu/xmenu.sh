#!/bin/sh

xmenu <<EOF | sh &
Applications
	Browser	$BROWSER
	filemanager		thunar
	calculator	galculator
	Gimp	gimp
	wallpaper	nitrogen
	torrent		qbittorrent
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
