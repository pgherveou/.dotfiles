return function(v)
  v.g.mapleader = ' ' -- Use space as leader!

  v.opt.autoindent = true -- Indent the next line matching the previous line
  v.opt.autoread = true -- Read file when it has been modified outside vim
  v.opt.autowrite = true -- write file when switching buffers
  v.opt.backspace = 'indent,eol,start' -- Backspace over everything in insert mode
  v.opt.clipboard = 'unnamedplus' -- Use system clipboard
  v.opt.cursorline = true -- Set the cursor line
  v.opt.encoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
  v.opt.expandtab = true -- Insert spaces instead of actual tabs
  v.opt.gdefault = true -- global substitution by default
  v.opt.history = 1000 -- The number of history items to remember
  v.opt.ignorecase = true -- Ignore case when searching
  v.opt.lazyredraw = true -- Don't redraw vim in all situations
  v.opt.mouse = 'a' -- Enable using the mouse if terminal emulator
  v.opt.startofline = false -- Keep cursor in the same place after saves
  v.opt.swapfile = false -- No swap file
  v.opt.wrap = false -- No line wrapping
  v.opt.number = true -- Set line Numbers
  v.opt.shiftround = true -- Round << and >> to multiples of shiftwidth
  v.opt.shiftwidth = 2 -- The space << and >> moves the lines
  v.opt.showcmd = true -- Show command information on the right side of the command line
  v.opt.smartcase = true -- Ignore case if search is lowercase, otherwise case-sensitive
  v.opt.smartindent = true -- Smart auto-indent when creating a new line
  v.opt.smarttab = true -- Delete entire shiftwidth of tabs when they're inserted
  v.opt.softtabstop = 2 -- Number of spaces for some tab operations
  v.opt.syntax = true -- Set syntax highlighting
  v.opt.t_Co = '256' -- Explicitly tell Vim that the terminal supports 256 colors
  v.opt.tabstop = 2 -- Number of spaces each tab counts for
  v.opt.termencoding = 'utf-8' -- Set the default encodings just in case $LANG isn't set
  v.opt.title = true -- Do not inherit the terminal title
  v.opt.ttyfast = true -- Set that we have a fast terminal
  v.opt.signcolumn = 'yes' -- always show the gutter
  v.opt.relativenumber = true -- relative number
  v.opt.pumheight = 10 -- maximum number of item to show in the completion menu
  v.opt.isfname = v.opt.isfname - { '=' } -- Remove characters from filenames for gf
  v.opt.wildignore = v.opt.wildignore -- Ignore these folders for completions
    .. ',.hg,.git,.svn' -- Version control
    .. ',*.jpg,*.bmp,*.gif,*.png,*.jpeg' -- binary images
    .. ',*.o,*.obj,*.exe,*.dll,*.manifest,*.pyc' -- compiled object files
    .. ',*.resolved,*.lock' -- package manager lock files
    .. ',*/node_modules/*' -- nodejs module
    .. ',tags,.tags'

  v.opt.formatoptions = v.opt.formatoptions -- " https://kinbiko.com/vim/my-shiniest-vim-gems/
    + { 'j' } -- Remove comments when joining lines with J
    - { 'o' } -- Don't continue comments with o and O

  v.opt.complete = '.,w,b,u,t,kspell' -- " Completion options
  v.opt.completeopt = 'menuone,noselect'
  v.opt.wildmenu = true -- Better completion in the CLI
  v.opt.wildmode = 'longest:full,full' -- Completion settings
  v.opt.undodir = v.fn.stdpath('cache') .. '/undo' -- set undodir
  return v
end
