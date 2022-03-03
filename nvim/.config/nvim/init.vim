runtime ./functions.vim
runtime ./options.vim
runtime ./autocmds.vim
runtime ./keymaps.vim
" runtime ./fold.vim
if exists('g:vscode')
  " ~/.config/nvim/lua/plugins/vscode.lua
  lua require('plugins.vscode')
else
  " ~/.config/nvim/lua/plugins/init.lua
  lua require('plugins')
endif

