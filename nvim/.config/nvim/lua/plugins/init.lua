local setup = require('plugins.setup')
require('plugins.globals')

setup(function(import)
  -- faster bootrsrap
  import('lewis6991/impatient.nvim').then_configure(function()
    require('impatient')
  end)

  -- Surround text.
  -- import('tpope/vim-surround')
  import('machakann/vim-sandwich')

  -- change case utilities
  import('icatalina/vim-case-change')

  -- comment/uncomment binding
  import('numToStr/Comment.nvim', 'JoosepAlviste/nvim-ts-context-commentstring').then_configure(function()
    require('Comment').setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    })
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

  -- treesitter scrolling
  -- import('nvim-treesitter/nvim-treesitter-context', 'nvim-treesitter/nvim-treesitter').then_configure(function()
  --   require('treesitter-context').setup()
  -- end)

  -- Syntax / languages
  import('sheerun/vim-polyglot')
  import({ 'fatih/vim-go', { ['do'] = ':GoUpdateBinaries' } }).then_configure(function()
    vim.g.go_term_reuse = 1
    vim.g.go_term_enabled = 1
    vim.g.go_term_close_on_exit = 0
    vim.g.go_term_mode = 'split'
    vim.g.go_test_timeout = '5s'
  end)

  import('narutoxy/silicon.lua', 'nvim-lua/plenary.nvim').then_configure(function()
    require('silicon').setup({})
    vim.api.nvim_set_keymap('v', '<leader>s', ':lua require("silicon").visualise_api({ to_clip = true })<cr>', {
      noremap = true,
    })
  end)

  -- search visually selected text
  import('nelstrom/vim-visual-star-search')

  -- import('windwp/nvim-ts-autotag').then_configure(function()
  --   require('nvim-ts-autotag').setup({ enable = true })
  -- end)
  -- indent guidelines
  import('lukas-reineke/indent-blankline.nvim', 'tpope/vim-sleuth').then_configure(function()
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
  import('ThePrimeagen/git-worktree.nvim')
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

  -- Treesitter ast / highlighting
  import(
    { 'nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' } },
    'nvim-treesitter/playground',
    'nvim-treesitter/nvim-treesitter-textobjects',
    'windwp/nvim-ts-autotag'
  ).then_configure(require('plugins.treesitter'))

  -- json navigation
  import('nvim-treesitter/nvim-treesitter', 'theprimeagen/jvim.nvim')

  -- lsp refactoring
  import('ThePrimeagen/refactoring.nvim', 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter').then_configure(
    function()
      require('refactoring').setup({})
    end
  )

  -- Telescope
  import(
    'nvim-telescope/telescope.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-github.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'ThePrimeagen/git-worktree.nvim',
    'ThePrimeagen/refactoring.nvim',
    'ThePrimeagen/harpoon',
    { 'nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' } }
  ).then_configure(require('plugins.telescope').setup)

  -- harpoon navigation
  import('nvim-lua/plenary.nvim', 'ThePrimeagen/harpoon').then_configure(require('plugins.harpoon').setup)

  -- snippets
  import('L3MON4D3/LuaSnip').then_configure(function()
    require('plugins.luasnip')
  end)

  -- lsp ts setup
  import(
    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',

    'williamboman/mason-lspconfig.nvim',
    'nvim-lua/plenary.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    'jose-elias-alvarez/null-ls.nvim',
    'ThePrimeagen/refactoring.nvim',
    'RRethy/vim-illuminate',
    'simrat39/rust-tools.nvim',
    'b0o/schemastore.nvim',
    'simrat39/symbols-outline.nvim',
    'mfussenegger/nvim-jdtls'
  ).then_configure(function()
    require('symbols-outline').setup()
    require('plugins.lsp.servers')()
  end)

  -- lsp progress
  import('j-hui/fidget.nvim').then_configure(function()
    require('fidget').setup({})
  end)

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
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip'
  ).then_configure(require('plugins.lsp.cmp'))

  -- lsp signatures
  import('ray-x/lsp_signature.nvim').then_configure(function()
    require('lsp_signature').setup()
  end)

  -- status line and Color Scheme
  import('folke/tokyonight.nvim', 'nvim-lualine/lualine.nvim', 'kyazdani42/nvim-web-devicons').then_configure(function()
    vim.cmd('colorscheme tokyonight')
    vim.g.tokyonight_style = 'storm'
    vim.g.tokyonight_italic_functions = true
    vim.g.tokyonight_italic_comments = true

    require('nvim-web-devicons').setup({
      default = true,
    })

    require('plugins.lualine')
  end)

  -- debugger
  import('mfussenegger/nvim-dap', 'rcarriga/nvim-dap-ui', 'simrat39/rust-tools.nvim').then_configure(function()
    require('dapui').setup()
  end)

  -- use obsidian from nvim
  import('epwalsh/obsidian.nvim').then_configure(function()
    require('obsidian').setup({
      dir = '~/Documents/notes',
      completion = {
        nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
      },
    })
  end)
end)
