return {
  'nanozuki/tabby.nvim',
  event = 'VeryLazy',
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    {
      '<leader>tt',
      function()
        local path = vim.fn.input('tcd: ', '', 'file')
        vim.cmd('tabnew')
        vim.cmd('tcd ' .. path)
      end,
      desc = 'New tab',
    },
    { '<leader>to', ':tabnew<CR>', desc = 'New tab' },
  },
  config = function()
    -- configs...
    require('tabby.tabline').use_preset('tab_only', {
      theme = {
        fill = 'TabLine', -- tabline background
        head = 'TabLine', -- head element highlight
        current_tab = 'TabLineSel', -- current tab label highlight
        tab = 'TabLine', -- other tab label highlight
        win = 'TabLine', -- window highlight
        tail = 'TabLine', -- tail element highlight
      },
      nerdfont = true, -- whether use nerdfont
      lualine_theme = nil, -- lualine theme name
      tab_name = {
        name_fallback = function(tabid)
          local number = vim.api.nvim_tabpage_get_number(tabid)
          local cwd = vim.fn.getcwd(-1, number)
          return vim.fn.fnamemodify(cwd, ':t')
        end,
      },
      -- buf_name = {
      --   mode = 'relative',
      -- },
    })
  end,
}
