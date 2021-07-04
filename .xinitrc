[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1 &
picom &
#picom --config /dev/null -i 0.8 --inactive-dim 0.2 &
sxhkd &
lxpolkit &
dunst &
nm-applet &
#parcellite &
nitrogen --restore &
emote &

setxkbmap -option caps:super &
xset r rate 300 50 &

kitty &

exec qtile start
