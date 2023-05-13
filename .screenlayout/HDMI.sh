#!/bin/sh
HDMIExisted=$(xrandr -q | grep connected | grep HDMI-1)
if [[ ! -z ${HDMIExisted} ]]; then
    xrandr --output eDP-1 --off --output HDMI-1 --primary --mode 3840x2160 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off
fi
