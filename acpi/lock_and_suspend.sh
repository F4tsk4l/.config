#!/bin/sh

LOCKFILE="/tmp/.acpi-lock-sleep"

# Avoid multiple triggers
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"

# Check lid state — skip suspend if already open (waking from sleep)
LID_STATE=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}')
if [ "$LID_STATE" = "open" ]; then
  rm -f "$LOCKFILE"
  exit 0
fi

# Lock the screen as desktop user
su -l g4m3r -c '
  export DISPLAY=:0
  export XAUTHORITY=/home/g4m3r/.Xauthority
  i3lock --radius 100 \
         -eki /home/g4m3r/Saver/shaded_landscape.png \
         -F --ring-width 3 --time-str="%H:%M" -p default
'

sleep 1
echo mem >/sys/power/state

# Cleanup lockfile shortly after resume
(sleep 3 && rm -f "$LOCKFILE") &
