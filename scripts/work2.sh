#!/bin/sh
xrandr --dpi 96 --output eDP-1 --mode 3840x2400 --rotate normal --right-of DP-3-3 --scale 0.5x0.5 \
 --output DP-3-3 --mode 1920x1080 --rotate normal --right-of DP-3-2  \
 --output DP-3-2 --mode 1920x1080 --rotate normal --primary 
