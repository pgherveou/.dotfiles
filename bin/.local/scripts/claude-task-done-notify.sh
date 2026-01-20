#!/usr/bin/env bash

# Claude Code task completion notification with tmux integration
# This script is called by Claude Code's Stop hook when a task completes

# Read hook input from stdin (though we don't use it currently)
read -r hook_input

# Function to send notification and handle action in background
send_notification() {
    local session_name="$1"
    local window_index="$2"
    local window_name="$3"

    if [ -z "$session_name" ]; then
        # Not in tmux, send generic notification
        dunstify -i "utilities-terminal" -t 10000 \
            "Claude Code" \
            "Task completed"
    else
        # Create display name
        local display_name="${session_name}:${window_name}"

        # Send notification with action button
        # Use -b to block and wait for user interaction
        local action_key=$(dunstify -i "utilities-terminal" -t 10000 \
            -A "jump,Jump to session" \
            "Claude Code" \
            "Task completed in ${display_name}")

        # If user clicked the action, execute the focus script
        if [ "$action_key" = "jump" ]; then
            /home/pg/.local/scripts/claude-focus-tmux.sh "$session_name" "$window_index"
        fi
    fi
}

# Check if we're in a tmux session and capture info
if [ -n "$TMUX" ]; then
    session_name=$(tmux display-message -p '#S')
    window_index=$(tmux display-message -p '#I')
    window_name=$(tmux display-message -p '#W')
else
    session_name=""
    window_index=""
    window_name=""
fi

# Run notification in background and exit immediately
send_notification "$session_name" "$window_index" "$window_name" &

exit 0
