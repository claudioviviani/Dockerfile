#!/bin/bash

export DISPLAY=:1
Xvfb :1 -screen 0 1600x900x16 &
sleep 5

startfluxbox&
x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &

# Create new .Xauthority file
xauth generate :1 . trusted 
randomkey=`/bin/bash -c 'echo $(( $RANDOM * $RANDOM * $RANDOM * $RANDOM * $RANDOM))'` 
xauth add ${HOST}:1 . $randomkey

cd /home/bbuser/noVNC && ln -s vnc_auto.html index.html && ./utils/launch.sh --vnc localhost:5900
