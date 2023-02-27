vim.g.mapleader = ' ' -- Use space as leader!
vim.opt.autoindent = true -- Indent the next line matching the previous line
vim.opt.autoread = true -- Read file when it has been modified outside vim
vim.opt.autowrite = true -- write file when switching buffers
vim.opt.backspace = 'indent,eol,start' -- Backspace over everything in insert mode
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.cursorline = true -- Set the cursor line
vim.opt.encoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
vim.opt.expandtab = true -- Insert spaces instead of actual tabs
vim.opt.gdefault = true -- global substitution by default
vim.opt.history = 1000 -- The number of history items to remember
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.lazyredraw = true -- Don't redraw vim in all situations
vim.opt.mouse = 'a' -- Enable using the mouse if terminal emulator
vim.opt.startofline = false -- Keep cursor in the same place after saves
vim.opt.swapfile = false -- No swap file
vim.opt.wrap = false -- No line wrapping
vim.opt.number = true -- Set line Numbers
vim.opt.shiftround = true -- Round << and >> to multiples of shiftwidth
vim.opt.shiftwidth = 2 -- The space << and >> moves the lines
vim.opt.showcmd = true -- Show command information on the right side of the command line
vim.opt.smartcase = true -- Ignore case if search is lowercase, otherwise case-sensitive
vim.opt.smartindent = true -- Smart auto-indent when creating a new line
vim.opt.smarttab = true -- Delete entire shiftwidth of tabs when they're inserted
vim.opt.softtabstop = 2 -- Number of spaces for some tab operations
vim.opt.tabstop = 2 -- Number of spaces each tab counts for
vim.opt.termencoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
vim.opt.title = true -- Do not inherit the terminal title
vim.opt.ttyfast = true -- Set that we have a fast terminal
vim.opt.signcolumn = 'yes' -- always show the gutter
vim.opt.relativenumber = true -- relative number
vim.opt.pumheight = 10 -- maximum number of item to show in the completion menu
vim.opt.laststatus = 3 -- always show the status line
-- vim.opt.cmdheight = 0 -- height of the command line

-- Ignore these folders for completions
vim.o.wildignore = vim.o.wildignore
  .. ',.hg,.git,.svn' -- Version control
  .. ',*.jpg,*.bmp,*.gif,*.png,*.jpeg' -- binary images
  .. ',*.o,*.obj,*.exe,*.dll,*.manifest,*.pyc' -- compiled object files
  .. ',*.resolved,*.lock' -- package manager lock files
  .. ',*/node_modules/*' -- nodejs module
  .. ',tags,.tags'

-- " https://kinbiko.com/vim/my-shiniest-vim-gems/
vim.opt.formatoptions:append('j') -- Remove comments when joining lines with J
vim.opt.formatoptions:remove('o')
-- " Completion options
vim.opt.complete = '.,w,b,u,t,kspell'

vim.opt.completeopt = 'menuone,noselect'
vim.opt.wildmenu = true -- Better completion in the CLI
vim.opt.wildmode = 'longest:full,full' -- Completion settings

-- set undodir
vim.opt.undodir = vim.fn.stdpath('cache') .. '/undo'
