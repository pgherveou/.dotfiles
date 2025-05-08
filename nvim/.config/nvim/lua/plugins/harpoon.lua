local navigation_entries = {}

for i = 1, 4 do
  table.insert(navigation_entries, {
    '<leader>' .. tostring(i),
    function()
      require('harpoon'):list():select(i)
    end,
    desc = 'Navigate to file ' .. i,
  })
end

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = true,

  config = function()
    local harpoon = require('harpoon')
    local default = require('harpoon.config').get_default_config().default

    harpoon.setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      -- if we want to use custom behavior for the harpoon menu
      -- default = {
      --   select = function(list_item, list, option)
      --     default.select(list_item, list, option)
      --   end,
      -- },
    })
  end,
  keys = {
    {
      '<leader>a',
      function()
        require('harpoon'):list():add()
      end,
      desc = 'Add file to harpoon',
    },
    {
      '<leader>h',
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end,
      desc = 'Toggle harpoon menu',
    },
    unpack(navigation_entries),
  },
}
