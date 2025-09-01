#!/bin/sh

# Detect username of active X session
USER=$(loginctl list-sessions 2>/dev/null | awk '/tty[0-9]/ {print $3; exit}')
[ -z "$USER" ] && USER=$(logname)

HOME_DIR=$(eval echo "~$USER")

# Detect active X display
DISPLAY_NUM=$(w -hs | awk '/tty[0-9]/ && /X/ {print $3; exit}')
[ -z "$DISPLAY_NUM" ] && DISPLAY_NUM=":0"   # fallback

# Detect XAUTHORITY
XAUTHORITY=$(ps -u "$USER" -o pid= | \
    xargs -I{} grep -z '^' /proc/{}/environ 2>/dev/null | \
    tr '\0' '\n' | awk -F= '/XAUTHORITY/ {print $2; exit}')
[ -z "$XAUTHORITY" ] && XAUTHORITY="$HOME_DIR/.Xauthority"

export DISPLAY="$DISPLAY_NUM"
export XAUTHORITY="$XAUTHORITY"

# Launch powermenu in user session
setsid su -l "$USER" -c "DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $HOME_DIR/.local/bin/powermenu" &
