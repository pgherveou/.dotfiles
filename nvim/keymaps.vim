" Use space as leader!
let g:mapleader="\<Space>"

" Remove search highlight.
nnoremap <silent> <Esc><Esc> :nohl<CR>

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Easier save mapping
nnoremap W :write<CR>

" better vertial movement for wrapped lines
nnoremap j gj
nnoremap k gk

" quickly cancel search highlighting
nnoremap <leader><space> :nohlsearch<cr>

" copy path into unnamed register
nmap cp :let @" = expand("%")<cr>

" source vim
noremap <leader>esv :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" :navigate quicklist and location list
nnoremap <leader>k :cnext<CR>zz
nnoremap <leader>j :cprev<CR>zz
nnoremap <leader>K :lnext<CR>zz
nnoremap <leader>J :lprev<CR>zz

" Go to previous buffer
nnoremap <leader>o :bprevious<cr>
nnoremap <leader>p :bnext<cr>

" Move line up / down
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Reselect visual blocks after movement
vnoremap < <gv
vnoremap > >gv

" split window
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w

" easy window resizing
nnoremap <M-Left> :vertical resize +1<cr>
nnoremap <M-Down> :resize -1<cr>
nnoremap <M-Up> :resize +1<cr>
nnoremap <M-Right> :vertical resize -1<cr>

" Edit the alternnate file
nmap <leader><leader> <c-^>


nmap <leader>n :call RenameFile()<cr>


nmap <leader>w :call StripTrailingWhitespace()<cr>

" fix gx to open files
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), 0)<CR>
