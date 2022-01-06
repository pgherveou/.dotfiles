#!/usr/bin/env bash
set -euo pipefail

pushd -q "$HOME/.dotfiles"

# install brew and the brewfile
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle install --file=Brewfile
fi

# create deeplinks to the home folder
STOW_FOLDERS=(
	"alacritty"
	"nvim"
	"codespell"
	"stylua"
	"tmux"
	"qmk"
	"zsh"
)

for folder in "${STOW_FOLDERS[@]}"; do
	stow -D "$folder"
	stow "$folder"
done

# clone tmux plugin manager
if [ ! -d ~/.tmux/plugins ]; then
	mkdir -p ~/.tmux
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# clone qmk firmware
if [ ! -d ~/qmk_firmware ]; then
	git clone https://github.com/qmk/qmk_firmware ~/qmk_firmware
	qmk setup -y
	qmk config user.keyboard=splitkb/kyria
	qmk config user.keymap=pgherveou
	qmk generate-compilation-database
	cp -f ~/qmk_firmware/compile_commands.json ~/.dotfiles/qmk/
fi

# install vimplug
vimplug="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f vimplug ]; then
	curl -fLo "$vimplug" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

popd -q
