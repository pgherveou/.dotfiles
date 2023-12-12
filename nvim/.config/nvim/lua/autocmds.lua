-- Don't auto insert a comment when using O/o for a newline
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufRead' }, {
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
    require('utils.formatter').bzl_formatter()
  end,
})

-- create vimrc augroup
vim.api.nvim_create_augroup('vimrc', { clear = true })

-- remove netrw map autocmd
vim.api.nvim_create_autocmd('FileType', {
  group = 'vimrc',
  pattern = 'netrw',
  callback = function()
    if vim.fn.hasmapto('<Plug>NetrwRefresh') > 0 then
      vim.api.nvim_buf_del_keymap(0, 'n', '<C-l>')
    end
  end,
})

-- wat use lisp for syntax highlighting
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group = 'vimrc',
  pattern = '*.wat',
  callback = function()
    vim.bo.filetype = 'lisp'
  end,
})

-- kill rust-analyzer
local kill_rust_analyzer = function()
  os.execute('kill -9 $(ps -ef | grep rust-analyzer | grep -v grep | awk \'{print $2}\')')
end

vim.api.nvim_create_user_command('KillRustAnalyzer', kill_rust_analyzer, {})

vim.api.nvim_create_user_command('RestartRustAnalyzer', function()
  vim.cmd('LspStop')
  kill_rust_analyzer()
  vim.cmd('BufReload')
  vim.cmd('LspRestart')
end, {})

-- support :<line> notation
vim.api.nvim_create_augroup('file_line', {})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  group = 'file_line',
  callback = function()
    local buffer = vim.fn.expand('%')
    local res = vim.fn.matchstrpos(buffer, ':[0-9]*$')

    if res[1] ~= '' then
      local line = string.sub(buffer, res[2] + 2)
      local file = string.sub(buffer, 0, res[2])

      -- delete buffer and start editing file at given number instead
      local bufnr = vim.fn.bufnr('%')
      vim.cmd('edit +' .. line .. ' ' .. file)
      vim.cmd('filetype detect')
      vim.cmd('bdelete ' .. bufnr)
    end
  end,
})
