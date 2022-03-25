#!/bin/sh

$HOME/.scripts/default.sh
#lxsession 
nitrogen --restore &
# picom &
volumeicon &
nm-applet &
blueman-applet &
xautolock -time 10 -locker 'slock' &
~/.local/bin/g810-led -dp c33c -p ~/.config/logitech-keyboard.profile
LG3D
