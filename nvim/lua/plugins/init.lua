local setup = require('plugins.setup')

setup(function(import)
  -- Surround text.
  import('tpope/vim-surround')

  -- comment/uncomment binding
  import('tpope/vim-commentary')

  -- Auto close parens, braces, brackets, etc
  import('jiangmiao/auto-pairs')

  -- Move to and from Tmux panes and Vim panes
  import('christoomey/vim-tmux-navigator')

  -- Smooth scrolling
  import('psliwka/vim-smoothie')

  -- Syntax For languages
  import('fatih/vim-go')
  import('cespare/vim-toml')
  import('rust-lang/rust.vim')
  import('uarun/vim-protobuf')
  import('plasticboy/vim-markdown')

  import('lukas-reineke/indent-blankline.nvim').then_configure(function()
    vim.opt.list = true
    require('indent_blankline').setup({
      show_current_context = true,
      show_current_context_start = true,
      indent_blankline_use_treesitter = true,
      indent_blankline_filetype_exclude = { 'help' },
    })
  end)

  -- Color Scheme
  import({ 'folke/tokyonight.nvim', { branch = 'main' } }, 'vim-airline/vim-airline', 'vim-airline/vim-airline-themes').then_configure(
    require('plugins.theme')
  )

  -- Highlight trailing whitespaces
  import('ntpeters/vim-better-whitespace')

  -- Treesitter ast / higlighting
  import('nvim-treesitter/nvim-treesitter', {
    'nvim-treesitter/nvim-treesitter-textobjects',
    { ['do'] = ':TSUpdate' },
  }).then_configure(require('plugins.treesitter'))

  -- Telescope
  import('nvim-telescope/telescope.nvim', { 'nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' } }).then_configure(
    require('plugins.telescope')
  )

  -- lsp & linter
  import('jose-elias-alvarez/null-ls.nvim', 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig').then_configure(
    require('plugins.lsp.null')
  )

  -- lsp ts setup
  import(
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'jose-elias-alvarez/nvim-lsp-ts-utils'
  ).then_configure(require('plugins.lsp.servers'))

  -- lsp completion
  import(
    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip'
  ).then_configure(require('plugins.lsp.cmp'))
end)
