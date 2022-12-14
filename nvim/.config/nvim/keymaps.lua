-- Use space as leader!
vim.g.mapleader = ' '

-- Remove search highlight.
vim.api.nvim_set_keymap(
  'n',
  '<Esc><Esc>',
  ':nohl<CR>',
  { noremap = true, silent = true, desc = 'Remove search highlight' }
)

-- Repeat last command
vim.api.nvim_set_keymap('n', '<leader>r', '@:', { noremap = true, silent = true, desc = 'Repeat last command' })

-- Don't copy the contents of an overwritten selection.
vim.api.nvim_set_keymap(
  'v',
  'p',
  '"_dP',
  { noremap = true, silent = true, desc = 'Don\'t copy the contents of an overwritten selection' }
)

-- better vertical movement for wrapped lines
vim.api.nvim_set_keymap('n', 'j', 'gj', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'k', 'gk', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'G', 'Gzz', { noremap = true, silent = true })

-- act like other capitalized actions
vim.api.nvim_set_keymap('n', 'Y', 'yg$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'YY', ':%y<cr>', { noremap = true, silent = true })

-- qq to record, Q to replay
vim.api.nvim_set_keymap('n', 'Q', '@q', { noremap = true, silent = true, desc = 'Replay macro' })

-- copy path into clipboard
vim.api.nvim_set_keymap(
  'n',
  '<leader>cp',
  ':let @+=expand("%:p")<CR>',
  { noremap = true, silent = true, desc = 'Copy path into clipboard' }
)

-- search and replace the visual selection
vim.api.nvim_set_keymap(
  'v',
  '<C-r>',
  [["hy:%s/<C-r>h//g<left><left>]],
  { noremap = true, desc = 'Search and replace the visual selection' }
)

-- search visual selection
vim.api.nvim_set_keymap(
  'v',
  '//',
  [[y/\V<C-R>=escape(@",'/\')<CR><CR>]],
  { noremap = true, desc = 'Search visual selection' }
)

-- make it easy to use cgn using the current word under the cursor
vim.api.nvim_set_keymap('n', 'c<Tab>', [[:let @/=expand('<cword>')<cr>cgn]], {
  noremap = true,
  silent = true,
  desc = 'Make it easy to use cgn using the current word under the cursor',
})

-- source vim
vim.api.nvim_set_keymap(
  'n',
  '<leader>sv',
  ':source $MYVIMRC<CR>',
  { noremap = true, silent = true, desc = 'Source vim' }
)

-- Add undo breakpoints, useful when used in combination with C-o u (one shot command + undo)
local breakpoints = { '<Del>', '!', '(', ')', ',', '.', '?', '[', '[' }
for _, v in ipairs(breakpoints) do
  vim.api.nvim_set_keymap('i', v, v .. '<C-g>u', { noremap = true, silent = true })
end

-- navigate quicklist and location list
vim.api.nvim_set_keymap(
  'n',
  '<Tab>j',
  ':cnext<CR>zz',
  { noremap = true, silent = true, desc = 'Go to next item in quicklist' }
)
vim.api.nvim_set_keymap(
  'n',
  '<Tab>k',
  ':cprev<CR>zz',
  { noremap = true, silent = true, desc = 'Go to previous item in quicklist' }
)
vim.api.nvim_set_keymap(
  'n',
  '<Tab>K',
  ':lprev<CR>zz',
  { noremap = true, silent = true, desc = 'Go to previous item in location list' }
)
vim.api.nvim_set_keymap(
  'n',
  '<Tab>J',
  ':lnext<CR>zz',
  { noremap = true, silent = true, desc = 'Go to next item in location list' }
)

-- navigate buffers
vim.api.nvim_set_keymap(
  'n',
  '<leader>o',
  ':bprevious<CR>',
  { noremap = true, silent = true, desc = 'Go to previous buffer' }
)
vim.api.nvim_set_keymap('n', '<leader>p', ':bnext<CR>', { noremap = true, silent = true, desc = 'Go to next buffer' })

-- Move line up / down
vim.api.nvim_set_keymap('n', '<M-j>', ':m .+1<CR>==', { noremap = true, silent = true, desc = 'Move line down' })
vim.api.nvim_set_keymap('n', '<M-k>', ':m .-2<CR>==', { noremap = true, silent = true, desc = 'Move line up' })
vim.api.nvim_set_keymap('i', '<M-j>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true, desc = 'Move line down' })
vim.api.nvim_set_keymap('i', '<M-k>', '<Esc>:m .-2<CR>==gi', { noremap = true, silent = true, desc = 'Move line up' })
vim.api.nvim_set_keymap('v', '<M-j>', ':m \'>+1<CR>gv=gv', { noremap = true, silent = true, desc = 'Move line down' })
vim.api.nvim_set_keymap('v', '<M-k>', ':m \'<-2<CR>gv=gv', { noremap = true, silent = true, desc = 'Move line up' })

-- Reselect visual blocks after movement
vim.api.nvim_set_keymap(
  'v',
  '<',
  '<gv',
  { noremap = true, silent = true, desc = 'Reselect visual blocks after movement' }
)
vim.api.nvim_set_keymap(
  'v',
  '>',
  '>gv',
  { noremap = true, silent = true, desc = 'Reselect visual blocks after movement' }
)

-- split window
vim.api.nvim_set_keymap('n', 'ss', ':split<CR><C-w>w', { noremap = true, silent = true, desc = 'Split window' })
vim.api.nvim_set_keymap('n', 'sv', ':vsplit<CR><C-w>w', { noremap = true, silent = true, desc = 'Split window' })

-- maximize minimize
-- nnoremap <C-w>m <C-w>\|<C-W>_
vim.api.nvim_set_keymap('n', '<C-w>m', '<C-w>|<C-W>_', { noremap = true, silent = true, desc = 'Maximize minimize' })

-- easy window resizing
vim.api.nvim_set_keymap(
  'n',
  '<M-Left>',
  ':vertical resize +1<CR>',
  { noremap = true, silent = true, desc = 'Increase split size vertically' }
)
vim.api.nvim_set_keymap(
  'n',
  '<M-Down>',
  ':resize -1<CR>',
  { noremap = true, silent = true, desc = 'Decrease split size horizontally' }
)
vim.api.nvim_set_keymap(
  'n',
  '<M-Up>',
  ':resize +1<CR>',
  { noremap = true, silent = true, desc = 'Resize horizontally' }
)
vim.api.nvim_set_keymap(
  'n',
  '<M-Right>',
  ':vertical resize -1<CR>',
  { noremap = true, silent = true, desc = 'Resize vertically' }
)

-- Edit the alternnate file
vim.api.nvim_set_keymap(
  'n',
  '<leader><leader>',
  '<C-^>',
  { noremap = true, silent = true, desc = 'Edit the alternnate file' }
)

-- fix gx to open files
vim.api.nvim_set_keymap(
  'n',
  'gx',
  ':call netrw#BrowseX(expand("<cfile>"), 0)<CR>',
  { noremap = true, silent = true, desc = 'Open file under cursor' }
)

-- Replay last command in tmux pane, by calling tmux send-keys -t bottom Up Enter
vim.api.nvim_set_keymap(
  'n',
  '<leader>tk',
  ':silent :!tmux send-keys -t bottom Up Enter<CR>',
  { noremap = true, silent = true, desc = 'Replay last command in tmux pane' }
)
