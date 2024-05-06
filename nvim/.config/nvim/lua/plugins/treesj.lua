return {
  'Wansmer/treesj',
  keys = {
    {
      '<leader>j',
      function()
        require('treesj').join()
      end,
      desc = 'Join node under cursor',
    },
    {
      '<leader>b',
      function()
        require('treesj').split()
      end,
      desc = 'Break node under cursor',
    },
  },
  lazy = true,
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
    })
  end,
}
