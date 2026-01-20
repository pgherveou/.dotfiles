#!/usr/bin/env bash

# Focus a specific tmux session and window
# Usage: claude-focus-tmux.sh <session_name> <window_index>

session_name="$1"
window_index="$2"

if [ -z "$session_name" ] || [ -z "$window_index" ]; then
    echo "Usage: $0 <session_name> <window_index>"
    exit 1
fi

# Target for tmux commands
target="${session_name}:${window_index}"

# Check if we're currently in tmux
if [ -n "$TMUX" ]; then
    # We're in tmux, use switch-client to jump to the target
    tmux switch-client -t "$target" 2>/dev/null
    if [ $? -ne 0 ]; then
        # If switch fails, notify the user
        dunstify -i "dialog-error" -t 5000 \
            "Claude Code" \
            "Failed to switch to ${target}"
    fi
else
    # We're not in tmux, use i3 to focus the terminal window
    # First, try to find a window running the tmux session
    # Get list of window IDs and check each one
    found=false

    for window_id in $(i3-msg -t get_tree | jq -r '.. | select(.window?) | .window'); do
        # Get the window's title or other properties to check if it's running our tmux session
        # This is a simple approach - we'll try to focus any terminal window
        # A more sophisticated approach would parse the window title
        :
    done

    # Simpler approach: Just try to attach with a new terminal
    # Check if the session exists first
    if tmux has-session -t "$session_name" 2>/dev/null; then
        # Launch a new terminal and attach to the session
        # Using i3-msg to execute the terminal command
        i3-msg exec "kitty -e tmux attach-session -t $target" >/dev/null 2>&1
    else
        dunstify -i "dialog-error" -t 5000 \
            "Claude Code" \
            "Tmux session ${session_name} not found"
    fi
fi
