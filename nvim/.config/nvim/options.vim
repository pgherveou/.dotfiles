set autoindent                 " Indent the next line matching the previous line
set autoread                   " Read file when it has been modified outside vim
set autowrite                  " write file when switching buffers
set backspace=indent,eol,start " Backspace settings
set clipboard+=unnamedplus     " Use OSX clipboard to copy and to paste
set cursorline                 " Set the cursor line
set encoding=utf-8             " Set the default encodings just in case $LANG isn't set
set expandtab                  " Insert spaces instead of actual tabs
set gdefault                   " global substitution by default
set history=1000               " The number of history items to remember
set ignorecase                 " Ignore case when searching
set isfname-==                 " Remove characters from filenames for gf
set lazyredraw                 " Don't redraw vim in all situations
set mouse=a                    " Enable using the mouse if terminal emulator
set nostartofline              " Keep cursor in the same place after saves
set noswapfile                 " No swap file
set nowrap                     " No line wrapping
set number                     " Set line Numbers
set shiftround                 " Round << and >> to multiples of shiftwidth
set shiftwidth=2               " The space << and >> moves the lines
set showcmd                    " Show command information on the right side of the command line
set smartcase                  " Ignore case if search is lowercase, otherwise case-sensitive
set smartindent                " Smart auto-indent when creating a new line
set smarttab                   " Delete entire shiftwidth of tabs when they're inserted
set softtabstop=2              " Number of spaces for some tab operations
set syntax                     " Set syntax highlighting
set t_Co=256                   " Explicitly tell Vim that the terminal supports 256 colors
set tabstop=2                  " Number of spaces each tab counts for
set termencoding=utf-8         " Set the default encodings just in case $LANG isn't set
set title                      " Do not inherit the terminal title
set ttyfast                    " Set that we have a fast terminal
set signcolumn=yes             " always show the gutter
set relativenumber             " relative number 
set pumheight=10               " maximum number of item to show in the completion menu
" Ignore these folders for completions
set wildignore+=.hg,.git,.svn                          " Version control
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg         " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.pyc " compiled object files
set wildignore+=*.resolved,*.lock                      " package manager lock files
set wildignore+=*/node_modules/*                       " nodejs module
set wildignore+=tags,.tags

" https://kinbiko.com/vim/my-shiniest-vim-gems/
" Remove comments when joining lines with J
set formatoptions+=j

" Completion options
set complete=.,w,b,u,t,kspell
set completeopt=menuone,noselect
set wildmenu                                           " Better completion in the CLI
set wildmode=longest:full,full                         " Completion settings

function! s:EnsureDirectory(directory)
  if !isdirectory(expand(a:directory))
    call mkdir(expand(a:directory), 'p')
  endif
endfunction

set undodir=$HOME/.tmp/vim/undo
call s:EnsureDirectory(&undodir)

