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
    local tab_name = function(number)
      local cwd = vim.fn.getcwd(-1, number)
      return vim.fn.fnamemodify(cwd, ':t')
    end

    local theme = {
      fill = 'TabLineFill',
      head = 'TabLine',
      current_tab = 'TabLineSel',
      tab = 'TabLine',
      win = 'TabLine',
      tail = 'TabLine',
    }
    require('tabby').setup({
      line = function(line)
        return {
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab
            return {
              line.sep(' ', hl, theme.fill),
              tab.number(),
              tab_name(tab.number()),
              line.sep(' ', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            return {
              line.sep(' ', theme.win, theme.fill),
              win.buf_name(),
              line.sep(' ', theme.win, theme.fill),
              hl = theme.win,
              margin = ' ',
            }
          end),
          hl = theme.fill,
        }
      end,
    })
  end,
}
