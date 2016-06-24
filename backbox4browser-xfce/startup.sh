#!/bin/bash

export DISPLAY=:1
export XDG_CONFIG_DIRS="/etc/xdg/xdg-backbox:/etc/xdg:/etc/xdg"
export XDG_DATA_DIRS="/usr/share/backbox:/usr/share/xfce4:/usr/share/:/usr/share"
Xvfb :1 -screen 0 1600x900x16 &
sleep 5

xfce4-session&
x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &

# Create new .Xauthority file
xauth generate :1 . trusted 
randomkey=`/bin/bash -c 'echo $(( $RANDOM * $RANDOM * $RANDOM * $RANDOM * $RANDOM))'` 
xauth add ${HOST}:1 . $randomkey

cd /home/bbuser/noVNC && ln -s vnc_auto.html index.html && ./utils/launch.sh --vnc localhost:5900
