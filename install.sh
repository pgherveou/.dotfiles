#!/usr/bin/env bash
set -euo pipefail

pushd "$HOME/.dotfiles"

# mac only
if [[ "$OSTYPE" == "darwin"* ]]; then
	# install brew if running from macos
	if ! command -v brew &>/dev/null; then
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi


	# ln -s /opt/homebrew/share/antigen/antigen.zsh ~/.antigen.zsh
	# brew bundle install
fi

# create deeplinks to the home folder
STOW_FOLDERS=(
	"alacritty"
	"git"
	"ideavim"
	"nvim"
	"codespell"
	"private"
	"tmux"
	"qmk"
	"zsh"
	"karabiner"
	"bin"
	"yabai"
	"skhdrc"
)

# clone tmux plugin manager
if [ ! -d ~/.tmux/plugins ]; then
	mkdir -p ~/.tmux/plugins
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# clone qmk firmware
if [ ! -d ~/qmk_firmware ]; then
	git clone https://github.com/qmk/qmk_firmware ~/qmk_firmware
	qmk setup -y
	qmk config user.keyboard=splitkb/kyria/rev1
	qmk config user.keymap=pgherveou
	qmk generate-compilation-database
	ln -s ~/qmk_firmware/compile_commands.json "$PWD"
fi

for folder in "${STOW_FOLDERS[@]}"; do
	stow -D "$folder"
	stow "$folder"
done

# list of globally installed npm packages
NPM_PKGS=(
	"neovim"
	"serve"
)

# install global npm packages using sudo on linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	sudo npm install -g "${NPM_PKGS[@]}"
else
	npm install -g "${NPM_PKGS[@]}"
fi

popd
