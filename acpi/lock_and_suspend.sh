#!/bin/sh

USER="sc0rp"
HOME_DIR="/home/$USER"

# Ignore accidental open events
grep -q closed /proc/acpi/button/lid/*/state || exit 0

# Lock screen
sudo -u "$USER" \
  DISPLAY=:0 \
  XAUTHORITY="$HOME_DIR/.Xauthority" \
  i3lock --radius 100 \
  -eki $HOME_DIR/Saver/shaded_landscape.png \
  -F --ring-width 3 --time-str='%H:%M' -p default &

# Allow lockscreen to appear
sleep 1

# Suspend
echo mem >/sys/power/state
