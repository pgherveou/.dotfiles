#!/bin/bash

# update global npm packages
IFS=' ' read -r -a NPM_PKGS_LIST <<<"$NPM_PKGS"
npm install -g "${NPM_PKGS_LIST[@]}"

# update global lua packages
IFS=' ' read -r -a LUA_PKGS_LIST <<<"$LUA_PKGS"
luarocks install "${LUA_PKGS_LIST[@]}"

# # brew updates
brew update
brew upgrade
brew cleanup
