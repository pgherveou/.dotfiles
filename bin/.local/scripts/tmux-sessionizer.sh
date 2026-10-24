#!/usr/bin/env bash
# source: https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer

if command -v fzf >/dev/null 2>&1; then
	FZF_BIN="fzf"
else
	FZF_BIN="$HOME/.fzf/bin/fzf"
fi

# select the target
if [[ $# -eq 1 ]]; then
	selected=$1
# use fzf to select the target
else
	export FZF_BIN DIRECTORIES
	DIRECTORIES=$(printf '%s\n' $(find -L ~/github -mindepth 1 -maxdepth 1 -type d) $(find ~ -mindepth 1 -maxdepth 1 -type l -exec test -d {} \; -print) "$HOME/.dotfiles")
	# the [new] entry goes after the ranked matches so an existing directory stays the default
	list_matches='echo "$DIRECTORIES" | $FZF_BIN --filter {q}; [ -z {q} ] || [ -d "$HOME"/github/{q} ] || echo "$HOME/github/"{q}" [new]"'
	selected=$(echo "$DIRECTORIES" | $FZF_BIN --no-sort --bind "change:reload($list_matches)")
	selected=${selected% \[new\]}
fi

# exit if no target selected
if [[ -z $selected ]]; then
	exit 0
fi

# clean up the target name
selected_name=$(basename "$selected" | tr . _)

# a typed name that is not a directory starts a single-pane session in ~/github
split_pane=true
if [[ ! -d $selected ]]; then
	selected="$HOME/github"
	split_pane=false
fi

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

	# open nvim in the first window and rename the window to "editor"
	tmux send-keys -t $selected_name "tmux rename-window 'nvim'" Enter
	tmux send-keys -t $selected_name "nv" Enter

	# open an empty shell in a vertical split on the first window
	if $split_pane; then
		tmux split-window -h -t $selected_name -c $selected
	fi

	# # create a second window and rename it to "shell"
	# tmux new-window -t $selected_name -n "shell" -c $selected
	#
	# # create a third window and rename it to "servers"
	# tmux new-window -t $selected_name -n "servers" -c $selected

	# focus on the first window
	tmux select-window -t $selected_name:1
fi

# switch to the selected session
tmux switch-client -t $selected_name
