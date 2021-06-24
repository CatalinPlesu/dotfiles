[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
picom &
#picom --config /dev/null -i 0.8 --inactive-dim 0.2 &
sxhkd &
lxpolkit &
dunst &
flameshot &
#parcellite &
nm-applet &
nitrogen --set-zoom-fill --set-color=#282828 --random ./Pictures/nice_wallpapers/ &

kitty &

exec qtile start
