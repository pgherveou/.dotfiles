return {
  'nanozuki/tabby.nvim',
  lazy = true,
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    {
      '<leader>tt',
      function()
        vim.cmd('tabnew')
        vim.api.nvim_feedkeys(':tcd ~/', 'n', false)
      end,
      desc = 'New tab',
    },
    { '<leader>to', ':tabnew<CR>', desc = 'New tab' },
  },
  config = function()
    require('tabby.tabline').use_preset('tab_only', {
      theme = {
        fill = 'TabLine', -- tabline background
        head = 'TabLine', -- head element highlight
        current_tab = 'TabLineSel', -- current tab label highlight
        tab = 'TabLine', -- other tab label highlight
        win = 'TabLine', -- window highlight
        tail = 'TabLine', -- tail element highlight
      },
      nerdfont = false, -- whether use nerdfont
      lualine_theme = nil, -- lualine theme name
      tab_name = {
        name_fallback = function(tabid)
          local number = vim.api.nvim_tabpage_get_number(tabid)
          local cwd = vim.fn.getcwd(-1, number)
          return vim.fn.fnamemodify(cwd, ':t')
        end,
      },
    })
  end,
}
