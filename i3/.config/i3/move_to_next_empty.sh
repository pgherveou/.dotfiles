#!/bin/bash
# Move focused container to next empty workspace and follow it

# Get the highest workspace number and add 1
next_ws=$(($(i3-msg -t get_workspaces | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1) + 1))

# Move container to that workspace
i3-msg "move container to workspace number $next_ws"

# Switch to that workspace
i3-msg "workspace number $next_ws"
