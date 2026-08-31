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
	mkdir -p "$HOME/Library/LaunchAgents" "$HOME/.cache"
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

setup_codex() {
	local operating_system="${1:-$(uname -s)}"
	local codex_home="${CODEX_HOME:-$HOME/.codex}"
	local config_path="$codex_home/config.toml"
	local dotfiles_root
	dotfiles_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
	local config_name

	case "$operating_system" in
	Darwin)
		config_name="config.macos.toml"
		;;
	Linux)
		config_name="config.linux.toml"
		;;
	*)
		echo "Unsupported operating system: $operating_system" >&2
		return 1
		;;
	esac

	local selected_config="$dotfiles_root/codex/$config_name"
	local backup_path="$codex_home/config.toml.before-dotfiles"
	local pending_link="$codex_home/config.toml.linking.$$"

	mkdir -p "$codex_home"

	stow -d "$dotfiles_root" -t "$codex_home" -D \
		--ignore='^config\.(macos|linux)\.toml$' \
		--ignore='^skills/\.system($|/)' \
		codex
	stow -d "$dotfiles_root" -t "$codex_home" \
		--ignore='^config\.(macos|linux)\.toml$' \
		--ignore='^skills/\.system($|/)' \
		codex

	if [ -e "$config_path" ] && [ ! -L "$config_path" ]; then
		if [ ! -f "$config_path" ]; then
			echo "Cannot replace non-file Codex config at $config_path" >&2
			return 1
		fi
		if [ -e "$backup_path" ] || [ -L "$backup_path" ]; then
			echo "Cannot preserve Codex config because $backup_path already exists" >&2
			return 1
		fi
		mv "$config_path" "$backup_path"
	fi

	ln -s "$selected_config" "$pending_link"
	mv -f "$pending_link" "$config_path"
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
	setup_codex

	pushd "$HOME/.private"
	stow -t ~/ ssh
	popd
}

# Run install when the script is executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	run_install
fi
