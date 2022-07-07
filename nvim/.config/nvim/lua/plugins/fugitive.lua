local function main_branch_name()
  local branch = vim.fn.system('git symbolic-ref refs/remotes/origin/HEAD | sed \'s@^refs/remotes/origin/@@\'')
  if branch ~= '' then
    return vim.trim(branch)
  else
    return ''
  end
end

local function setup()
  vim.api.nvim_set_keymap('n', '<leader>gs', ':vertical G<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gj', ':diffget //3<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gf', ':diffget //2<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>grc', ':G rebase --continue<cr>', { noremap = true })
  vim.keymap.set('n', '<leader>gm', function()
    local branch = main_branch_name()
    local expr = ':Gvsplit ' .. branch .. ':%<cr>'
    return expr
  end, { noremap = true, expr = true })
end

return setup
