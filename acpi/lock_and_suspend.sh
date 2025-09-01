#!/bin/sh

LOCKFILE="/tmp/.acpi-lock-sleep"

# Avoid multiple triggers
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"

# Detect username of active X session (first logged-in user with X)
USER=$(who | awk '/tty[0-9]/ {print $1; exit}')
[ -z "$USER" ] && USER=$(logname)   # fallback

HOME_DIR=$(eval echo "~$USER")

# Check lid state — skip if already open
LID_STATE=$(awk '{print $2}' /proc/acpi/button/lid/*/state)
if [ "$LID_STATE" = "open" ]; then
  rm -f "$LOCKFILE"
  exit 0
fi

# Lock the screen as the desktop user
su -l "$USER" -c "
  export DISPLAY=:0
  export XAUTHORITY=$HOME_DIR/.Xauthority
  i3lock --radius 100 \
         -eki $HOME_DIR/Saver/shaded_landscape.png \
         -F --ring-width 3 --time-str='%H:%M' -p default
"

# Suspend system
echo mem > /sys/power/state

# Cleanup
rm -f "$LOCKFILE"
