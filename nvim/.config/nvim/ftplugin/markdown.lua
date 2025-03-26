vim.opt.foldenable = false
vim.opt.wrap = true
vim.opt.linebreak = true

vim.api.nvim_set_keymap('n', '<leader>m', ':RenderMarkdown toggle<CR>', { noremap = true, silent = true })
