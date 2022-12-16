local l = require('plugins.legendary')

-- stylua: ignore start
l.keymaps({
  ['<leader>tc'] = { mode = 'n', cmd = ':lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>', desc = 'Toggle harpoon quick menu' },
  ['<leader>a'] = { mode = 'n', cmd = ':lua require("harpoon.mark").add_file()<CR>', desc = 'Add file to harpoon' },
  ['<leader>h'] = { mode = 'n', cmd = ':lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Toggle harpoon menu' },
  ['<leader>j'] = { mode = 'n', cmd = ':lua require("harpoon.ui").nav_file(1)<CR>', desc = 'Navigate to file 1' },
  ['<leader>k'] = { mode = 'n', cmd = ':lua require("harpoon.ui").nav_file(4)<CR>', desc = 'Navigate to file 2' },
  ['<leader>l'] = { mode = 'n', cmd = ':lua require("harpoon.ui").nav_file(4)<CR>', desc = 'Navigate to file 3' },
  ['<leader>;'] = { mode = 'n', cmd = ':lua require("harpoon.ui").nav_file(5)<CR>', desc = 'Navigate to file 4' },
})
-- stylua: ignore end
