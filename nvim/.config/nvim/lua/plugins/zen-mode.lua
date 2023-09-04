return {
  'folke/zen-mode.nvim',
  lazy = true,
  keys = {
    {
      '<leader>z',
      ':ZenMode<CR>',
      desc = 'Zen mode',
      silent = true,
    },
  },
  config = function()
    require('zen-mode').setup({})
  end,
}
