#!/usr/bin/sh

/usr/bin/prime-offload

if [ $(xrandr | grep 'connected' | wc -l) = "2" ]; then
  # xrandr --output HDMI-0 --mode 2560x1440 --pos 0x0 --rotate normal --output eDP-1-1 --primary --mode 1920x1080 --pos 2560x100 --rotate normal &
  xrandr --output eDP-1-1 --primary --mode 1920x1080 --rotate normal --output HDMI-0 --mode 1920x1080 --rotate normal --above eDP-1-1 &
fi

i3 && sudo /usr/bin/prime-switch
