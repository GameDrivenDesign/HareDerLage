#!/bin/bash

#Xvfb :99 -ac -screen 0 1280x720x16 -nolisten tcp &
#xvfb=$!

#export DISPLAY=:99
export DISPLAY=:0
export XDG_CACHE_HOME=/home/developer/cache
export XDG_DATA_HOME=/home/developer/data
export XDG_CONFIG_HOME=/home/developer/config
mkdir -p /home/developer/build/output
mkdir -p /home/developer/data
mkdir -p /home/developer/cache
mkdir -p /home/developer/config

sleep 3
/home/developer/build/godot --export "HTML5" --path /home/developer/build /home/developer/build/output/index.html
