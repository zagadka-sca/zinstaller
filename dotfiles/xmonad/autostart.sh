#!/bin/sh

#$HOME/.scripts/default.sh
#lxsession 
nitrogen --restore &
picom &
volumeicon &
nm-applet &
blueman-applet &
trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 0  --transparent true --alpha 0 --tint 0x282c34  --height 16 &
gnome-screensaver &
xautolock -time 10 -locker 'slock' &
#~/.local/bin/g810-led -dp c33c -p ~/.config/logitech-keyboard.profile
LG3D
