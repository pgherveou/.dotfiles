require('commands')
require('options')
require('keymaps')
require('autocmds')

if vim.g.vscode then
  require('plugins.vscode')
else
  require('plugins')
end
