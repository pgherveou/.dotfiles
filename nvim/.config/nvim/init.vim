runtime ./functions.vim
runtime ./options.vim
runtime ./autocmds.vim
runtime ./keymaps.vim

augroup vimrc
  autocmd!
  autocmd FileType netrw call s:RemoveNetrwMap()
augroup END

function s:RemoveNetrwMap()
  if hasmapto('<Plug>NetrwRefresh')
    unmap <buffer> <C-l>
  endif
endfunction

" runtime ./fold.vim

if exists('g:vscode')
  " ~/.config/nvim/lua/plugins/vscode.lua
  lua require('plugins.vscode')
else
  " ~/.config/nvim/lua/plugins/init.lua
  lua require('plugins')
endif

