require('plugins.globals')

local plugins = {
  -- zen-mode
  {
    'folke/zen-mode.nvim',
    lazy = true,
    config = function()
      require('zen-mode').setup({})
    end,
  },

  -- file explorer
  {
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
  },

  {
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      vim.defer_fn(function()
        require('copilot').setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end, 100)
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    dependencies = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  -- Surround text.
  'machakann/vim-sandwich',

  -- change case utilities
  'icatalina/vim-case-change',

  -- comment/uncomment binding
  {
    'numToStr/Comment.nvim',
    dependencies = { 'JoosepAlviste/nvim-ts-context-commentstring', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  },

  -- Auto close parens, braces, brackets, etc
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt' },
      })
    end,
  },

  -- Move to and from Tmux panes and Vim panes
  'christoomey/vim-tmux-navigator',

  -- Smooth scrolling
  'psliwka/vim-smoothie',

  -- adjusts indentation based on filetype
  'tpope/vim-sleuth',

  -- install fatih/vim-go and install binaries if needed
  {
    'fatih/vim-go',
    build = ':GoUpdateBinaries',
    config = function()
      vim.g.go_term_reuse = 1
      vim.g.go_term_enabled = 1
      vim.g.go_term_close_on_exit = 0
      vim.g.go_term_mode = 'split'
      vim.g.go_test_timeout = '5s'
    end,
  },

  -- see https://github.com/sheerun/vim-polyglot#language-packs
  -- for installing more language packs

  -- take screenshots
  {
    'narutoxy/silicon.lua',
    dependencies = 'nvim-lua/plenary.nvim',
    lazy = true,
    config = function()
      local silicon = require('silicon')
      silicon.setup({})
      vim.keymap.set('v', '<leader>s', function()
        silicon.visualise_api({ to_clip = true })
      end, { silent = true })
    end,
  },

  -- search visually selected text
  'nelstrom/vim-visual-star-search',

  -- TODO disable for large file
  -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/440#issuecomment-1310520274pe/vim-sleuth
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      vim.opt.list = true
      require('indent_blankline').setup({
        show_current_context = true,
        show_current_context_start = true,
        indent_blankline_use_treesitter = true,
        indent_blankline_filetype_exclude = { 'help' },
      })
    end,
  },

  -- :S command and cr command for case coercing
  'tpope/vim-abolish',

  -- git integration
  'ruanyl/vim-gh-line', -- gh links for text
  { 'tpope/vim-fugitive', config = require('plugins.fugitive') },
  {
    'lewis6991/gitsigns.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- highlight yanked text
  'machakann/vim-highlightedyank',

  -- Treesitter ast / highlighting
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    build = ':TSUpdate',
    config = require('plugins.treesitter'),
  },

  -- json navigation
  {
    'theprimeagen/jvim.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  -- lsp refactoring
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('refactoring').setup({})
    end,
  },

  -- lua lsp
  { 'folke/neodev.nvim' },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'ThePrimeagen/git-worktree.nvim',
      'ThePrimeagen/refactoring.nvim',
      'ThePrimeagen/harpoon',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('plugins.telescope')()
    end,
  },

  -- harpoon navigation
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = require('plugins.harpoon'),
  },

  -- snippets
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('plugins.luasnip')
    end,
  },

  -- lsp ts setup
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'nvim-lua/plenary.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      'jose-elias-alvarez/null-ls.nvim',
      'jayp0521/mason-null-ls.nvim',
      'RRethy/vim-illuminate',
      'simrat39/rust-tools.nvim',
      'b0o/schemastore.nvim',
      'simrat39/symbols-outline.nvim',
      'mfussenegger/nvim-jdtls',
      'ThePrimeagen/refactoring.nvim',
    },
    config = function()
      require('symbols-outline').setup()
      require('plugins.lsp.servers')()
      require('mason-null-ls').setup({
        ensure_installed = { 'stylua', 'jq', 'codespell' },
      })
    end,
  },

  -- lsp progress
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end,
  },

  -- cmp completion
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'neovim/nvim-lspconfig',
      'nvim-lua/lsp_extensions.nvim',
      'zbirenbaum/copilot.lua',
    },
    config = require('plugins.lsp.cmp'),
  },

  -- lsp signatures
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  },

  -- status line and Color Scheme
  {
    'folke/tokyonight.nvim',
    dependencies = {
      'nvim-lualine/lualine.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      vim.cmd('colorscheme tokyonight')
      vim.g.tokyonight_style = 'storm'
      vim.g.tokyonight_italic_functions = true
      vim.g.tokyonight_italic_comments = true

      require('nvim-web-devicons').setup({
        default = true,
      })

      require('plugins.lualine')
    end,
  },

  -- debugger
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'simrat39/rust-tools.nvim',
    },
    config = require('plugins.dap'),
  },
}

-- bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require('lazy').setup(plugins, {})
