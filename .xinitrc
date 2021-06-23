[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
picom &
sxhkd &
lxpolkit &
dunst &
flameshot &
parcellite &
nm-applet &
#mate-power-manager &
xfce4-power-manager &
volumeicon &
nitrogen --set-zoom-fill --set-color=#282828 --random ./Pictures/nice_wallpapers/ &

kitty &

exec qtile start
