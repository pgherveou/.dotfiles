#!/usr/bin/env bash
# Break the current tmux pane into a new session.
# Invoked via the `break-tos` command alias (type `:break-tos` in the tmux prompt),
# which prompts for the session name (pre-filled with the cwd basename);
# run-shell expands the invoking pane's formats and passes them here as arguments.
# Args: <pane_id> <window_id> <window_panes> <pane_current_path> [session_name]
# An empty session_name falls back to the cwd basename.
# If a session with that name already exists, the pane is merged into it instead.
set -u

src=$1 winid=$2 panes=$3 cwd=$4
name=${5:-}
[ -n "$name" ] || name=$(basename "$cwd")

# With >1 pane, peel this pane into its own window first; a lone pane means the
# window itself is what we relocate.
if [ "$panes" -gt 1 ]; then
  win=$(tmux break-pane -d -s "$src" -P -F '#{window_id}')
else
  win=$winid
fi

if tmux has-session -t "=$name" 2>/dev/null; then
  tmux move-window -s "$win" -t "$name:99" && tmux move-window -r -t "$name"
else
  tmux new-session -d -s "$name" -c "$cwd" \
    && tmux move-window -s "$win" -t "$name:99" \
    && tmux kill-window -t "$name:1" \
    && tmux move-window -r -t "$name"
fi

tmux switch-client -t "$name"
