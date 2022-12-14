" runtime ./functions.vim
" runtime ./options.vim
" runtime ./autocmds.vim
" runtime ./keymaps.vim
luafile ~/.config/nvim/commands.lua
luafile ~/.config/nvim/options.lua
luafile ~/.config/nvim/autocmds.lua
luafile ~/.config/nvim/keymaps.lua

augroup vimrc
  autocmd!
  autocmd FileType netrw call s:RemoveNetrwMap()
augroup END

function s:RemoveNetrwMap()
  if hasmapto('<Plug>NetrwRefresh')
    unmap <buffer> <C-l>
  endif
endfunction

if exists('g:vscode')
  lua require('plugins.vscode')
else
  lua require('plugins')
endif

