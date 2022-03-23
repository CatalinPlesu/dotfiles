#!/bin/sh

## open terminal
# super + Return
	$TERMINAL -e tmux new-session -A -s main

# ctrl + alt + t
	$TERMINAL -e tmux new-session -A -s main

# super + alt + Return
	$TERMINAL	
# super + b
	$BROWSER

# super + x
	xsecurelock -- xset dpms force off

# Print
	scrot -z '%d-%B-%Y-{%T}.png' -e 'xclip -selection clipboard -t "image/png" -i $n && mkdir -p ~/Pictures/Screenshots/%Y/%B/%d/ && mv $f ~/Pictures/Screenshots/%Y/%B/%d/'

### Print + alt ; {1-9}
##	scrot -z -d {1-9}'%d-%B-%Y-{%T}.png' -e 'xclip -selection clipboard -t "image/png" -i $n && mkdir -p ~/Pictures/Screenshots/%Y/%B/%d/ && mv $f ~/Pictures/Screenshots/%Y/%B/%d/'

# ctrl + Print
	scrot -zs '%d-%B-%Y-{%T}.png' -e 'xclip -selection clipboard -t "image/png" -i $n && mkdir -p ~/Pictures/Screenshots/%Y/%B/%d/ && mv $f ~/Pictures/Screenshots/%Y/%B/%d/'

# shift + Print
	flameshot gui

## rofi things
# super + d
	rofi -show combi 

# super + r; c
	rofi -show calc | xclip -selection clipboard

# super + r; e
	rofi -modi 'run,drun,emoji:/home/catalin/.config/rofi/rofiemoji.sh' -show emoji  -matching glob

## Change wallpaper
# super + r ; w
	nitrogen --set-zoom-fill --random ~/Pictures/wallpapers

## Change theme
# super + r ; t
	switch

## apps 
## super + alt + {g, b, f, v, z, s, m}
##   {gimp, $BROWSER, thunar, virtualbox, zathura, stickers, mpv av://v4l2:/dev/video0 --profile=low-latency --untimed -vf=hflip}
# super + m
	mpv av://v4l2:/dev/video0 --profile=low-latency --untimed -vf=hflip

## file browser in directory
# super + f ; {t, b, s, d, p, v, m, u, w}
	thunar {Documents/latex, Books, Pictures/xiaomi/pics/stickers/,Downloads, Pictures, Videos, Music, UTM/ii_an/iv_sem/, Pictures/wallpapers/}
# super + u

	find -L ~/UTM/ii_an/iv_sem/ -type d | rofi -dmenu | xargs --no-run-if-empty thunar 
# super + n
    book=$(find ~/Books -type f | rofi -dmenu -i) && zathura $book

## # various terminal programs
## super + alt + {a, r, h, n, w, p}
##   $TERMINAL -e {alsamixer, lf, htop, nvim, nvim ~/Documents/notes/index.md, pulsemixer}

### audio
# XF86AudioRaiseVolume
	vol.sh up	

## amixer -D pulse sset Master 5%+
# XF86AudioLowerVolume
	vol.sh down

## amixer -D pulse sset Master 5%-
# XF86AudioMute
	vol.sh mute

## amixer -D pulse sset Master toggle
# XF86AudioMicMute
	amixer -D pulse sset Capture toggle

### Brightness
# XF86MonBrightnessUp
	backlight_control +5
# XF86MonBrightnessDown
	backlight_control -5

### keyboard language 
# super + r; 1
	setxkbmap us
# super + r; 2
	setxkbmap ro std
# super + r; 3
	setxkbmap ru
