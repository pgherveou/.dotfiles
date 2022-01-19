local function setup()
  vim.api.nvim_set_keymap('n', '<leader>gs', ':G<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gj', ':diffget //3<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>gf', ':diffget //2<cr>', { noremap = true })
  vim.api.nvim_set_keymap('n', '<leader>grc', ':G rebase --continue<cr>', { noremap = true })
end
return setup
