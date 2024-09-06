return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = true,
  config = function()
    -- https://github.com/nvim-pack/nvim-spectre/issues/118#issuecomment-1531683211
    require('spectre').setup({
      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = {
            '-i',
            '',
            '-E',
          },
        },
      },
    })
  end,
  keys = {
    {
      '<leader>sr',
      function()
        require('spectre').open()
      end,
      desc = 'Replace in files (Spectre)',
    },
    {
      '<leader>sr',
      function()
        -- escape the visual selection and open spectre
        local current_selection = vim.fn.getreg('s')
        -- escape current selection so that we can search text with sed
        local escaped_text = vim.fn.escape(current_selection, '( )')
        vim.fn.setreg('s', escaped_text)

        require('spectre').open_visual()
      end,
      mode = 'v',
      desc = 'Replace selection in files (Spectre)',
    },
  },
}
