vim.o.autoindent = true -- Indent the next line matching the previous line
vim.o.autoread = true -- Read file when it has been modified outside vim
vim.o.autowrite = true -- write file when switching buffers
vim.o.backspace = 'indent,eol,start' -- Backspace over everything in insert mode
vim.o.clipboard = 'unnamedplus' -- Use system clipboard
vim.o.cursorline = true -- Set the cursor line
vim.o.encoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
vim.o.expandtab = true -- Insert spaces instead of actual tabs
vim.o.gdefault = true -- global substitution by default
vim.o.history = 1000 -- The number of history items to remember
vim.o.ignorecase = true -- Ignore case when searching
vim.opt.isfname:remove('=') -- Remove characters from filenames for gf
vim.o.lazyredraw = true -- Don't redraw vim in all situations
vim.o.mouse = 'a' -- Enable using the mouse if terminal emulator
vim.o.startofline = false -- Keep cursor in the same place after saves
vim.o.swapfile = false -- No swap file
vim.o.wrap = false -- No line wrapping
vim.o.number = true -- Set line Numbers
vim.o.shiftround = true -- Round << and >> to multiples of shiftwidth
vim.o.shiftwidth = 2 -- The space << and >> moves the lines
vim.o.showcmd = true -- Show command information on the right side of the command line
vim.o.smartcase = true -- Ignore case if search is lowercase, otherwise case-sensitive
vim.o.smartindent = true -- Smart auto-indent when creating a new line
vim.o.smarttab = true -- Delete entire shiftwidth of tabs when they're inserted
vim.o.softtabstop = 2 -- Number of spaces for some tab operations
vim.o.syntax = true -- Set syntax highlighting
vim.o.t_Co = '256' -- Explicitly tell Vim that the terminal supports 256 colors
vim.o.tabstop = 2 -- Number of spaces each tab counts for
vim.o.termencoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
vim.o.title = true -- Do not inherit the terminal title
vim.o.ttyfast = true -- Set that we have a fast terminal
vim.o.signcolumn = 'yes' -- always show the gutter
vim.o.relativenumber = true -- relative number
vim.o.pumheight = 10 -- maximum number of item to show in the completion menu

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
vim.o.complete = '.,w,b,u,t,kspell'

vim.o.completeopt = 'menuone,noselect'
vim.o.wildmenu = true -- Better completion in the CLI
vim.o.wildmode = 'longest:full,full' -- Completion settings

-- set undodir
vim.o.undodir = vim.fn.stdpath('cache') .. '/undo'
