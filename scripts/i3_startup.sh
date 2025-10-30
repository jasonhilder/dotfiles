#!/bin/bash

# Kill existing processes
pkill picom
pkill nm-applet
pkill volumeicon
pkill dunst
pkill autotiling

# Wait for processes to terminate
while pgrep -x picom >/dev/null; do sleep 0.1; done
while pgrep -x volumeicon >/dev/null; do sleep 0.5; done
while pgrep -x nm-applet >/dev/null; do sleep 0.1; done
while pgrep -x dunst >/dev/null; do sleep 0.1; done
while pgrep -x autotiling >/dev/null; do sleep 0.1; done

# Set wallpaper
feh --bg-scale ~/Pictures/wallpapers/kanagawa.jpg &

# Start applications
picom -b &
volumeicon &
nm-applet &
dunst &
autotiling &
