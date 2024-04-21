local mappings = {
  n = {
    -- Remove search highlight.
    ['<Esc>'] = { ':nohl<CR>:echo<CR>', desc = 'Remove search highlight' },

    -- Repeat last command
    ['<leader>rc'] = { '@:', desc = 'Repeat last command' },

    -- better vertical movement for wrapped lines
    ['j'] = { 'gj' },
    ['k'] = { 'gk' },
    ['G'] = { 'Gzz' },

    -- act like other capitalized actions
    ['Y'] = { 'yg$' },
    ['YY'] = { ':%y<cr>' },

    -- Paste without carriage return
    ['<leader>p'] = {
      function()
        local content = vim.fn.getreg('"')
        content = content:gsub('\n$', '')
        vim.api.nvim_put({ content }, 'c', true, true)
      end,
      desc = 'Paste without carriage return',
    },
    ['<leader>P'] = {
      function()
        local content = vim.fn.getreg('"')
        content = content:gsub('\n$', '')
        vim.api.nvim_put({ content }, 'c', false, true)
      end,
      desc = 'Paste without carriage return',
    },

    -- new line from normal mode
    ['<leader>o'] = { ':normal! o<CR>' },
    ['<leader>O'] = { ':normal! O<CR>' },

    -- select yanked text
    ['gy'] = { '`[v`]' },

    ['<leader>y'] = {
      function()
        local text = vim.fn.getreg('"')
        if vim.fn.has('mac') == 1 then
          vim.fn.system('nc localhost 8377', text)
        else
          vim.fn.system('nc -N localhost 8377', text)
        end
      end,
      desc = 'Clip yank text to make it available in the clipboard',
    },

    -- qq to record, Q to replay
    ['Q'] = { '@q', desc = 'Replay macro' },

    -- copy path into clipboard
    ['<leader>cp'] = { ':let @+=expand("%:p")<CR>', desc = 'Copy path into clipboard' },

    -- cd to the current folder
    ['<leader>cd'] = { ':cd %:h<CR>', desc = 'Change directory to the current file' },
    ['<leader>lcd'] = { ':lcd %:h<CR>', desc = 'Change local directory to the current file' },

    -- make it easy to use cgn using the current word under the cursor
    ['c<Tab>'] = { [[:let @/=expand('<cword>')<cr>cgn]], desc = 'Use cgn using the current word under the cursor' },

    -- source vim
    ['<leader>SV'] = { ':source $MYVIMRC<CR>', desc = 'Source vim' },

    -- navigate quicklist and location list
    ['<Tab>j'] = { ':cnext<CR>zz', desc = 'Go to next item in quicklist' },
    ['<Tab>k'] = { ':cprev<CR>zz', desc = 'Go to previous item in quicklist' },
    ['<Tab>K'] = { ':lprev<CR>zz', desc = 'Go to previous item in location list' },
    ['<Tab>J'] = { ':lnext<CR>zz', desc = 'Go to next item in location list' },
    ['<leader>q'] = { ':AddToQuickFix', desc = 'Add current line to quick fix list' },

    -- Move line up / down
    ['<M-j>'] = { ':m .+1<CR>==', desc = 'Move line down' },
    ['<M-k>'] = { ':m .-2<CR>==', desc = 'Move line up' },

    -- split window
    ['ss'] = { ':split<CR><C-w>w', desc = 'Split window' },
    ['sv'] = { ':vsplit<CR><C-w>w', desc = 'Split window' },

    -- maximize minimize
    ['<C-w>m'] = { '<C-w>|<C-W>_', desc = 'Maximize minimize' },

    -- easy window resizing
    ['<M-Left>'] = { ':vertical resize +1<CR>', desc = 'Increase split size vertically' },
    ['<M-Down>'] = { ':resize -1<CR>', desc = 'Decrease split size horizontally' },
    ['<M-Up>'] = { ':resize +1<CR>', desc = 'Resize horizontally' },
    ['<M-Right>'] = { ':vertical resize -1<CR>', desc = 'Resize vertically' },

    -- Edit the alternnate file
    ['<leader><leader>'] = { '<C-^>', desc = 'Edit the alternnate file' },

    -- fix gx to open files
    ['gx'] = { ':!open <cfile><CR>', desc = 'Open file under cursor' },

    -- Replay last command in tmux pane, by calling tmux send-keys -t bottom Up Enter
    ['<leader>tk'] = { ':silent :!tmux send-keys -t bottom Up Enter<CR>', desc = 'Replay last command in tmux pane' },

    -- open the pull request
    ['<leader>gv'] = { ':!gh pr view --web<CR>', desc = 'Open the pull request with gh in the web browser' },
  },
  x = {
    -- execute macro on selected lines
    ['Q'] = { ':normal @q<CR>', desc = 'Execute macro on selected lines' },

    -- Don't copy the contents of an overwritten selection.
    ['p'] = { '"_dP', desc = 'Don\'t copy the contents of an overwritten selection' },

    -- search and replace the visual selection
    ['<C-r>'] = { [["hy:%s/<C-r>h//g<left><left>]], desc = 'Search and replace the visual selection' },

    -- search visual selection
    ['//'] = { [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], desc = 'Search visual selection' },

    -- move selected lines up and down
    ['<M-j>'] = { ':m \'>+1<CR>gv=gv', desc = 'Move line down' },
    ['<M-k>'] = { ':m \'<-2<CR>gv=gv', desc = 'Move line up' },

    -- Reselect visual blocks after movement
    ['<'] = { '<gv', desc = 'Reselect visual blocks after movement' },
    ['>'] = { '>gv', desc = 'Reselect visual blocks after movement' },
  },
  i = {
    -- move current lint up and down
    ['<M-j>'] = { '<Esc>:m .+1<CR>==gi', desc = 'Move line down' },
    ['<M-k>'] = { '<Esc>:m .-2<CR>==gi', desc = 'Move line up' },
  },
}

-- delete empty lines with dd, go to the black hole register
vim.keymap.set('n', 'dd', function()
  if vim.fn.getline('.') == '' then
    return '"_dd'
  end
  return 'dd'
end, { expr = true })

-- Add undo breakpoints, useful when used in combination with C-o u (one shot command + undo)
for _, v in ipairs({ '<Del>', '!', '(', ')', ',', '.', '?', '[', '[' }) do
  mappings['i'][v] = { v .. '<C-g>u' }
end

require('utils').keymaps(mappings)
