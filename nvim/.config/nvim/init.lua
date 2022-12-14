require('commands')
require('options')
require('autocmds')
require('keymaps')

if vim.g.vscode then
  require('plugins.vscode')
else
  require('plugins')
end
