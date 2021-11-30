" vscode keymaps
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
nnoremap <leader>f <Cmd>call VSCodeNotify('workbench.action.findInFiles', { 'query': expand('<cword>')})<CR>
nnoremap <leader>p <Cmd>call VSCodeNotify('workbench.action.findInFiles')<CR>

"vscode plugs
Plug 'tpope/vim-surround'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" TODO
"if exists('g:vscode')
"  source ~/.config/nvim/treesitter.lua
"else
"  let g:airline_theme='simple'
"  let g:lightline = {'colorscheme': 'tokyonight'}

"  let g:tokyonight_style = "storm"
"  let g:tokyonight_italic_functions = 1

"  let g:better_whitespace_enabled=1
"  let g:strip_whitespace_on_save=1
"  let g:strip_whitespace_confirm=0

"  "Load the colorscheme
"  " colorscheme gruvbox
"  colorscheme tokyonight

"  luafile ~/.config/nvim/treesitter.lua
"  luafile ~/.config/nvim/telescope.lua
"  luafile ~/.config/nvim/lspconfig.lua
"  luafile ~/.config/nvim/cmp.lua
"endif


