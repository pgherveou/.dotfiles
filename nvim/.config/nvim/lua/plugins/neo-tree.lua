return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v2.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Open file explorer' },
    { '<leader>E', '<cmd>NeotreeReveal<cr>', desc = 'Reveal current file in neo-tree' },
  },
  config = function()
    require('neo-tree').setup({
      close_if_last_window = true,
      enable_git_status = false,
    })
  end,
}
