#!/usr/bin/env bash
# source: https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

# select the target
if [[ $# -eq 1 ]]; then
	selected=$1
# use fzf to select the target
else
	selected=$(find -L ~/github ~/ -mindepth 1 -maxdepth 1 -type d | fzf)
fi

# exit if no target selected
if [[ -z $selected ]]; then
	exit 0
fi

# clean up the target name
selected_name=$(basename "$selected" | tr . _)

# check if tmux is running
tmux_running=$(pgrep tmux)

# if tmux is not running, start a new session
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	tmux new-session -s $selected_name -c $selected
	exit 0
fi

# if tmux is running, but the selected session is not, create it
if ! tmux has-session -t=$selected_name 2>/dev/null; then
	tmux new-session -ds $selected_name -c $selected
fi

# switch to the selected session
tmux switch-client -t $selected_name

