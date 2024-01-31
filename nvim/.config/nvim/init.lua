require('globals')
require('commands')
require('options')
require('keymaps')
require('autocmds')

-- bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  require('vscode')
else
  require('lazy').setup('plugins', {
    dev = {
      path = vim.env.HOME .. '/github',
    },
  })
end
