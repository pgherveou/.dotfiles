#!/usr/bin/env bash

current_session="$(tmux display-message -p '#S')"

# if the session we attached to is ssh turn off all tmux key bindings from the top level tmux
if [[ "$current_session" == "atlas" ]]; then
	not_ssh="[[ '#{pane_current_command}' != 'atlas' ]]"
	tmux if-shell "$not_ssh" 'send-keys "ssh atlas.local" C-m'

	tmux set key-table off
	tmux set prefix None
	tmux set status off

# if we are back to the main session turn them back on
# elif [[ "$current_session" == "main" ]]; then
else
	tmux set -u prefix
	tmux set -u key-table
	tmux set status on
fi
