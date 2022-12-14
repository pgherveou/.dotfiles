-- Don't auto insert a comment when using O/o for a newline
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead', 'FileType *' }, {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove('o')
  end,
})

-- run keymapviz for keymap.c files
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = vim.fn.expand('~') .. '/.dotfiles/qmk/**/keymap.c',
  callback = function()
    vim.cmd('silent !keymapviz --config ~/.dotfiles/keymapviz/config.properties -t fancy -r <afile>')
    vim.cmd('edit')
    vim.cmd('redraw!')
  end,
})

-- format bazel files
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*.bzl,*.bazel,WORKSPACE,BUILD',
  callback = function()
    require('plugins.formatter').bzl_formatter()
  end,
})
