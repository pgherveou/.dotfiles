local navigation_entries = {}

for i = 1, 4 do
  table.insert(navigation_entries, {
    tostring(i),
    function()
      require('harpoon.ui').nav_file(i)
    end,
    desc = 'Navigate to file ' .. i,
  })
end

return {
  'ThePrimeagen/harpoon',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = true,
  keys = {
    {
      '<leader>tc',
      function()
        require('harpoon.cmd-ui').toggle_quick_menu()
      end,
      desc = 'Toggle harpoon quick menu',
    },
    {
      '<leader>a',
      function()
        require('harpoon.mark').add_file()
      end,
      desc = 'Add file to harpoon',
    },
    {
      '<leader>h',
      function()
        require('harpoon.ui').toggle_quick_menu()
      end,
      desc = 'Toggle harpoon menu',
    },
    unpack(navigation_entries),
  },
}
