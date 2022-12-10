" Use space as leader!
let g:mapleader="\<Space>"

" Remove search highlight.
nnoremap <silent> <Esc><Esc> :nohl<CR>

" Repeat last command
nnoremap <leader>r @:<CR>

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" better vertical movement for wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap G Gzz

"act like other capitalized actions
nnoremap Y yg$
nnoremap YY :%y<cr>

" qq to record, Q to replay
nnoremap Q @q

" quickly cancel search highlighting
nnoremap <leader><space> :nohlsearch<cr>

" copy path into clipboard
nmap cp :let @* = expand("%")<cr>

" search and replace the visual selection
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" search visual selection
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" make it easy to use cgn using the current word under the cursor 
nnoremap <silent> c<Tab> :let @/=expand('<cword>')<cr>cgn

" redirect last command to register 
nnoremap <silent> <leader>red :redir @"> <bar> <C-r>: <bar> redir END<cr>

" source vim
noremap <leader>esv :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Add undo breakpoints, useful when used in combination with C-o u (one shot
" command + undo)
inoremap <Del> <c-g>u<Del>
inoremap ! !<c-g>u
inoremap ( (<c-g>u
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap [ [<c-g>u
inoremap { {<c-g>u 

" :navigate quicklist and location list
nnoremap <Tab>j :cnext<CR>zz
nnoremap <Tab>k :cprev<CR>zz
nnoremap <Tab>J :lnext<CR>zz
nnoremap <Tab>K :lprev<CR>zz

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
nnoremap ss :split<Return><C-w>w
nnoremap sv :vsplit<Return><C-w>w

" maximize minimize
nnoremap <C-w>m <C-w>\|<C-W>_

" easy window resizing
nnoremap <M-Left> :vertical resize +1<cr>
nnoremap <M-Down> :resize -1<cr>
nnoremap <M-Up> :resize +1<cr>
nnoremap <M-Right> :vertical resize -1<cr>

" Edit the alternnate file
nmap <leader><leader> <c-^>

" Toggle edit between the header and cc file
" map <leader>s :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" fix gx to open files
nnoremap gx :call netrw#BrowseX(expand('<cfile>'), 0)<CR>

" Replay last command in tmux pane
" nmap <leader>tk  !tmux send-keys -t bottom Up Enter<CR>
