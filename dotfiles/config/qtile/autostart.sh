#!/bin/sh

#$HOME/.scripts/default.sh
#lxsession 
nitrogen --restore &
picom &
volumeicon &
nm-applet &
gnome-screensaver &
xautolock -time 10 -locker 'gnome-screensaver-command -l' &
~/.local/bin/g810-led -dp c33c -p ~/.config/logitech-keyboard.profile
LG3D
