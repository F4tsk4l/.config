#!/bin/bash
xprop -id $(xdotool getwindowfocus) -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY 0xccffffff
