return function()
  -- stylua: ignore start
  require('utils').keymaps({
      ['n'] = {
        ['<leader>tc'] = { function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = 'Toggle harpoon quick menu' },
        ['<leader>a'] = { function() require("harpoon.mark").add_file() end, desc = 'Add file to harpoon' },
        ['<leader>h'] = { function() require("harpoon.ui").toggle_quick_menu() end, desc = 'Toggle harpoon menu' },
        ['<leader>j'] = { function() require("harpoon.ui").nav_file(1) end, desc = 'Navigate to file 1' },
        ['<leader>k'] = { function() require("harpoon.ui").nav_file(2) end, desc = 'Navigate to file 2' },
        ['<leader>l'] = { function() require("harpoon.ui").nav_file(3) end, desc = 'Navigate to file 3' },
        ['<leader>;'] = { function() require("harpoon.ui").nav_file(4) end, desc = 'Navigate to file 4' },
      }
})
  -- stylua: ignore end
end
