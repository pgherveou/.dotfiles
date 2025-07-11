#!/bin/bash

# Get used workspace numbers on this output
workspaces=$(i3-msg -t get_workspaces | jq -r '.[].name')
used_numbers=$(echo "$workspaces" | sed -n "s/^\([0-9]\+\).*/\1/p" | sort -n | uniq)

# Find the first unused workspace number starting from 1
next=1
while echo "$used_numbers" | grep -qx "$next"; do
  next=$((next + 1))
done

# Move container and switch to the new workspace
i3-msg "move container to workspace number $next; workspace number $next"
