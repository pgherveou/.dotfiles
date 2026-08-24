#!/usr/bin/env bash

# Function to add a cron job
add_cron_job() {
	local script_path="$1"
	local time_schedule="$2"

	# Check if the cron job is already scheduled
	if crontab -l | grep -q "$script_path"; then
		echo "Cron job $script_path already scheduled."
	else
		# Add the cron job with the specified time schedule
		(
			crontab -l
			echo "$time_schedule $script_path"
		) | crontab -
		echo "Cron job $script_path scheduled with $time_schedule."
	fi
}

setup_qmk() {
	qmk setup -y
	qmk config user.keyboard=splitkb/kyria/rev1
	qmk config user.keymap=pgherveou
	qmk generate-compilation-database
	ln -s ~/qmk_firmware/compile_commands.json "$PWD"
}

install_cargo_bin() {
	# install cargo binaries
	CARGO_BIN=(
		"cargo-watch"
		"evcxr_repl"
		"silicon"
		"sccache"
	)

	for bin in "${CARGO_BIN[@]}"; do
		cargo install "$bin"
	done
}

# mac equivalent of the linux systemd timers: hourly background jobs
setup_launch_agents() {
	mkdir -p "$HOME/Library/LaunchAgents"
	stow -D launchd
	stow launchd

	local uid
	uid=$(id -u)
	for plist in launchd/Library/LaunchAgents/*.plist; do
		local label
		label=$(basename "$plist" .plist)
		launchctl bootout "gui/$uid/$label" 2>/dev/null || true
		launchctl bootstrap "gui/$uid" "$HOME/Library/LaunchAgents/$label.plist"
		echo "Loaded launch agent $label"
	done
}

setup_cron_jobs() {
	# cleanup rust projects every day at 7am
	add_cron_job "$HOME/.dotfiles/bin/.local/scripts/rust_projects_cleanup.sh" "0 7 * * *"
}

run_install() {
	set -euo pipefail
	pushd "$HOME/.dotfiles"

	# mac only
	if [[ "$OSTYPE" == "darwin"* ]]; then
		# keyboard repeat rate
		defaults write -g KeyRepeat -int 1
		defaults write -g InitialKevRepeat -int 13

		# install brew if running from macos
		if ! command -v brew &>/dev/null; then
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		fi

		ln -s .tmux-macos.conf .tmux.conf
		# ln -s /opt/homebrew/share/antigen/antigen.zsh ~/.antigen.zsh
		# brew bundle install

		setup_launch_agents
	else
		ln -sf .tmux-linux.conf .tmux.conf
	fi

	# clone tmux plugin manager
	if [ ! -d ~/.tmux/plugins ]; then
		mkdir -p ~/.tmux/plugins
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	fi

	# # clone qmk firmware
	# if [ ! -d ~/qmk_firmware ]; then
	# 	git clone https://github.com/qmk/qmk_firmware ~/qmk_firmware
	# fi

	# create deeplinks to the home folder
	STOW_FOLDERS=(
		"git"
		"nvim"
		"codespell"
		"private"
		"tmux"
		"qmk"
		"zsh"
		"karabiner"
		"bin"
		"hammerspoon"
		"cargo"
		"atuin"
		"opencode"
	)

	for folder in "${STOW_FOLDERS[@]}"; do
		echo "Stowing $folder"
		stow -D "$folder"
		stow "$folder"
	done

	# claude needs --no-folding to avoid symlinking the .claude dir itself
	echo "Stowing claude"
	stow -D claude
	stow --no-folding claude

	# codex skills: target ~/.codex so the whole skills dir folds into a single
	# symlink (~/.codex/skills -> repo). codex writes its system skills into
	# skills/.system, which is gitignored. Do not pre-create ~/.codex/skills, or
	# stow can't fold it into one symlink.
	echo "Stowing codex"
	mkdir -p "$HOME/.codex"
	stow -t "$HOME/.codex" -D codex
	stow -t "$HOME/.codex" codex

	pushd "$HOME/.private"
	stow -t ~/ ssh
	popd
}

# Run install when the script is executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	run_install
fi
