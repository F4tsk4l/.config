#!/bin/sh

LOCKFILE="/tmp/.acpi-lock-sleep"

# Avoid multiple triggers in a short window
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"

# Check lid state — skip suspend if lid is already open (resume case)
LID_STATE=$(awk '{print $2}' /proc/acpi/button/lid/*/state)
if [ "$LID_STATE" = "open" ]; then
  rm -f "$LOCKFILE"
  exit 0
fi

# Lock the screen as the desktop user
su -l g4m3r -c '
  export DISPLAY=:0
  export XAUTHORITY=/home/g4m3r/.Xauthority
  i3lock --radius 100 \
         -eki /home/g4m3r/Saver/shaded_landscape.png \
         -F --ring-width 3 --time-str="%H:%M" -p default
'

# Suspend system
echo mem > /sys/power/state

# Cleanup lockfile after resume
rm -f "$LOCKFILE"
