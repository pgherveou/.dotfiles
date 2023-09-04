return {
  'stevearc/aerial.nvim',
  lazy = true,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { 'gs', '<cmd>AerialToggle right<CR>', desc = 'Toggle Symbols outline' },
  },
  config = function()
    require('aerial').setup()
  end,
}
