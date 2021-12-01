local setup = require('plugins.setup')

setup(function(import)
  -- Surround text.
  import('tpope/vim-surround')

  -- comment/uncomment binding
  import('tpope/vim-commentary')

  -- Treesitter ast / higlighting
  import('nvim-treesitter/nvim-treesitter', {
    'nvim-treesitter/nvim-treesitter-textobjects',
    { ['do'] = ':TSUpdate' },
  }).then_configure(require('plugins.treesitter'))
end)
