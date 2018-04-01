#!/bin/bash

export XDG_CACHE_HOME=/tmp/cache
export XDG_DATA_HOME=/tmp/data
export XDG_CONFIG_HOME=/tmp/config
mkdir -p /tmp/build/output
mkdir -p /tmp/data
mkdir -p /tmp/cache
mkdir -p /tmp/config

/tmp/build/godot --export "HTML5" --path /tmp/build /tmp/build/output/index.html
