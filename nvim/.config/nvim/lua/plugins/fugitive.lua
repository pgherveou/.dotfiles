-- local function main_branch_name()
--   local branch = vim.fn.system('git symbolic-ref refs/remotes/origin/HEAD | sed \'s@^refs/remotes/origin/@@\'')
--   if branch ~= '' then
--     return vim.trim(branch)
--   else
--     return ''
--   end
-- end
-- vim.keymap.set('n', '<leader>gm', function()
--   local branch = main_branch_name()
--   local expr = ':Gvsplit ' .. branch .. ':%<cr>'
--   return expr
-- end, { noremap = true, expr = true })

local function setup()
  local l = require('plugins.legendary')
  l.keymaps({
    ['<leader>gs'] = { mode = 'n', cmd = ':vertical G<cr>', desc = '[Git] status window' },
    ['<leader>gj'] = { mode = 'n', cmd = ':diffget //3<cr>', desc = '[Git] Pick diffget 3' },
    ['<leader>gf'] = { mode = 'n', cmd = ':diffget //2<cr>', desc = '[Git] Pick diffget 2' },
    ['<leader>grc'] = { mode = 'n', cmd = ':G rebase --continue<cr>', desc = '[Git] Continue rebase' },
  })
end

return setup
