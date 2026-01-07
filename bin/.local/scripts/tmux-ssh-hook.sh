#!/usr/bin/env bash

current_session="$(tmux display-message -p '#S')"

if [[ "$current_session" == ssh* ]]; then
	name="${current_session#ssh_}"
	not_ssh="[[ '#{pane_current_command}' != 'ssh' ]]"
	tmux if-shell "$not_ssh" "send-keys 'ssh $name' C-m"
	tmux set key-table off
	tmux set prefix None
	tmux set status off

# if we are back to the main session flip settings back on
else
	tmux set -u prefix
	tmux set -u key-table
	tmux set status on
fi
