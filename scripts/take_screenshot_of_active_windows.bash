#!/bin/bash

maim -i "$(xdotool getactivewindow)" Downloads/screenshot.png && notify-send "Active window screenshot saved to ~/Downloads/screenshot.png"

