#!/bin/sh

LOCKFILE="/tmp/.acpi-lock-sleep"

# Avoid multiple triggers
[ -f "$LOCKFILE" ] && exit 0
touch "$LOCKFILE"

# Detect username of active X session
USER=$(loginctl list-sessions 2>/dev/null | awk '/tty[0-9]/ {print $3; exit}')
[ -z "$USER" ] && USER=$(logname)

HOME_DIR=$(eval echo "~$USER")

# Detect active X display and Xauthority
DISPLAY_NUM=$(w -hs | awk '/tty[0-9]/ && /X/ {print $3; exit}')
[ -z "$DISPLAY_NUM" ] && DISPLAY_NUM=":0"   # fallback
XAUTHORITY=$(ps -u "$USER" -o pid= | \
    xargs -I{} grep -z '^' /proc/{}/environ 2>/dev/null | \
    tr '\0' '\n' | awk -F= '/XAUTHORITY/ {print $2; exit}')

[ -z "$XAUTHORITY" ] && XAUTHORITY="$HOME_DIR/.Xauthority"

# Check lid state — skip if already open
LID_STATE=$(awk '{print $2}' /proc/acpi/button/lid/*/state)
if [ "$LID_STATE" = "open" ]; then
  rm -f "$LOCKFILE"
  exit 0
fi

# Lock the screen as the desktop user
su -l "$USER" -c "
  export DISPLAY=$DISPLAY_NUM
  export XAUTHORITY=$XAUTHORITY
  i3lock --radius 100 \
         -eki $HOME_DIR/Saver/shaded_landscape.png \
         -F --ring-width 3 --time-str='%H:%M' -p default
"

# Suspend system
echo mem > /sys/power/state

# Cleanup
rm -f "$LOCKFILE"
