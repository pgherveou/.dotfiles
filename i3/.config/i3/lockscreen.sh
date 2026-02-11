#!/bin/bash
# Disable DPMS to avoid input issues after monitor wake
xset dpms 0 0 0

# Lock the screen
betterlockscreen -l -- --show-failed-attempts -p win

# Re-enable DPMS after unlock
xset dpms 600 600 600
