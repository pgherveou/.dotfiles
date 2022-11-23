#!/usr/bin/env bash
set -euo pipefail

pushd "$HOME/.dotfiles"

# TODO(pg) mac only
# install brew and the brewfile
# if ! command -v brew &>/dev/null; then
# 	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# 	brew bundle install --file=Brewfile
# fi

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
)

# list of globally installed npm packages
NPM_PKGS=(
	"neovim"
	"serve"
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

# install global npm packages
sudo npm install -g "${NPM_PKGS[@]}"

# install vimplug
vimplug="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f vimplug ]; then
	curl -fLo "$vimplug" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# TODO(pg) mac only
# setup spectacle
# cp -r spectacles/Shortcuts.json "$HOME/Library/Application Support/Spectacle/Shortcuts.json" 2>/dev/null

popd
