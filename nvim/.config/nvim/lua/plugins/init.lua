local setup = require('plugins.setup')
require('plugins.globals')

setup(function(import)
  -- Surround text.
  -- import('tpope/vim-surround')
  import('machakann/vim-sandwich')

  -- change case utilities
  import('icatalina/vim-case-change')

  -- CopyRTF to copy highlighted text to clipboard
  -- import('zerowidth/vim-copy-as-rtf')
  import('google/vim-maktaba', 'google/vim-glaive', 'google/vim-syncopate')

  -- comment/uncomment binding
  import('numToStr/Comment.nvim').then_configure(function()
    require('Comment').setup()
  end)

  -- Auto close parens, braces, brackets, etc
  -- import('jiangmiao/auto-pairs')
  import('windwp/nvim-autopairs').then_configure(function()
    require('nvim-autopairs').setup({
      disable_filetype = { 'TelescopePrompt' },
    })
  end)

  -- Move to and from Tmux panes and Vim panes
  import('christoomey/vim-tmux-navigator')

  -- Smooth scrolling
  import('psliwka/vim-smoothie')

  -- Syntax For languages
  import('sheerun/vim-polyglot')

  -- indent guidelines
  import('lukas-reineke/indent-blankline.nvim').then_configure(function()
    vim.opt.list = true
    require('indent_blankline').setup({
      show_current_context = true,
      show_current_context_start = true,
      indent_blankline_use_treesitter = true,
      indent_blankline_filetype_exclude = { 'help' },
    })
  end)

  -- git integration
  import('ruanyl/vim-gh-line') -- gh links for text
  import('tpope/vim-fugitive').then_configure(require('plugins.fugitive'))
  import('nvim-lua/plenary.nvim', 'lewis6991/gitsigns.nvim').then_configure(function()
    require('gitsigns').setup()
  end)

  -- git reviews
  import(
    'pwntester/octo.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'kyazdani42/nvim-web-devicons'
  ).then_configure(function()
    require('octo').setup()
  end)

  -- highlight yanked text
  import('machakann/vim-highlightedyank')

  -- auto select the root directory
  -- import('airblade/vim-rooter').then_configure(function()
  --   vim.g.rooter_patterns = { '.git', 'Cargo.lock' }
  -- end)

  -- Treesitter ast / highlighting
  import(
    { 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } },
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects'
  ).then_configure(require('plugins.treesitter'))

  -- json navigation
  import('nvim-treesitter/nvim-treesitter', 'theprimeagen/jvim.nvim')

  --toggle quicklist location list with leader q or l
  import('milkypostman/vim-togglelist')

  -- Telescope
  import(
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-rg.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-github.nvim',
    'ThePrimeagen/harpoon',
    { 'nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' } }
  ).then_configure(require('plugins.telescope').setup)

  -- harpoon navigation
  import('nvim-lua/plenary.nvim', 'ThePrimeagen/harpoon').then_configure(require('plugins.harpoon').setup)

  -- lsp ts setup
  import(
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    'jose-elias-alvarez/null-ls.nvim',
    'RRethy/vim-illuminate',
    'simrat39/rust-tools.nvim',
    'nvim-lua/lsp-status.nvim'
  ).then_configure(require('plugins.lsp.servers'))

  -- lsp completion
  import(
    'neovim/nvim-lspconfig',
    'nvim-lua/lsp_extensions.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip'
  ).then_configure(require('plugins.lsp.cmp'))

  -- lsp signatures
  import('ray-x/lsp_signature.nvim').then_configure(function()
    require('lsp_signature').setup()
  end)

  -- status line and Color Scheme
  import(
    'nvim-lua/lsp-status.nvim',
    'folke/tokyonight.nvim',
    'nvim-lualine/lualine.nvim',
    'kyazdani42/nvim-web-devicons'
  ).then_configure(function()
    vim.cmd('colorscheme tokyonight')
    vim.g.tokyonight_style = 'storm'
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_italic_comments = true

    require('nvim-web-devicons').setup({
      default = true,
    })

    require('plugins.lualine')
  end)
end)
