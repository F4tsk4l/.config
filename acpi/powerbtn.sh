#!/bin/bash

USER="Username"
USER_HOME="/home/$USER"
export DISPLAY=:0
export XAUTHORITY="$USER_HOME/.Xauthority"

# Start powermenu within user's X session so it behaves like a keybinding-triggered launch
setsid su -l "$USER" -c "DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $USER_HOME/.local/bin/powermenu" &
