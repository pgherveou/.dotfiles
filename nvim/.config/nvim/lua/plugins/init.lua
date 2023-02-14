require('plugins.globals')

local load_plugins = function(use)
  -- faster bootrsrap
  use({
    'lewis6991/impatient.nvim',
    config = function()
      require('impatient')
    end,
  })

  -- file explorer
  use({
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v2.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle<cr>', { desc = 'Open file explorer' })
      vim.keymap.set('n', '<leader>E', '<cmd>NeotreeReveal<cr>', { desc = 'Reveal current file in neo-tree' })
      require('neo-tree').setup({
        close_if_last_window = true,
        enable_git_status = false,
      })
    end,
  })

  -- cheatsheet for keymaps
  -- use({
  --   'folke/which-key.nvim',
  --   config = function()
  --     require('which-key').setup({
  --       window = {
  --         border = 'rounded',
  --         padding = { 2, 2, 2, 2 },
  --       },
  --     })
  --   end,
  -- })

  use({
    'zbirenbaum/copilot.lua',
    event = 'VimEnter',
    config = function()
      vim.defer_fn(function()
        require('copilot').setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
          -- suggestion = {
          --   auto_trigger = true,
          --   keymap = {
          --     accept = '<M-l>',
          --     next = '<M-]>',
          --     prev = '<M-[>',
          --     dismiss = '<C-]>',
          --   },
          -- },
        })
      end, 100)
    end,
  })

  use({
    'zbirenbaum/copilot-cmp',
    after = { 'copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  })

  -- Surround text.
  use('machakann/vim-sandwich')

  -- change case utilities
  use('icatalina/vim-case-change')

  -- comment/uncomment binding
  use({
    'numToStr/Comment.nvim',
    requires = { 'JoosepAlviste/nvim-ts-context-commentstring', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      })
    end,
  })

  -- Auto close parens, braces, brackets, etc
  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        disable_filetype = { 'TelescopePrompt' },
      })
    end,
  })

  -- Move to and from Tmux panes and Vim panes
  use('christoomey/vim-tmux-navigator')

  -- Smooth scrolling
  use('psliwka/vim-smoothie')

  -- treesitter scrolling
  -- use('nvim-treesitter/nvim-treesitter-context', 'nvim-treesitter/nvim-treesitter').config(function()
  --   require('treesitter-context').setup()
  -- end)

  -- Syntax / languages
  use('sheerun/vim-polyglot')

  -- install fatih/vim-go and install binaries if needed
  use({
    'fatih/vim-go',
    run = ':GoUpdateBinaries',
    config = function()
      vim.g.go_term_reuse = 1
      vim.g.go_term_enabled = 1
      vim.g.go_term_close_on_exit = 0
      vim.g.go_term_mode = 'split'
      vim.g.go_test_timeout = '5s'
    end,
  })

  -- take screenshots
  use({
    'narutoxy/silicon.lua',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      local silicon = require('silicon')
      silicon.setup({})
      vim.keymap.set('v', '<leader>s', function()
        silicon.visualise_api({ to_clip = true })
      end, { silent = true })
    end,
  })

  -- search visually selected text
  use('nelstrom/vim-visual-star-search')

  -- TODO disable for large file
  -- https://github.com/lukas-reineke/indent-blankline.nvim/issues/440#issuecomment-1310520274pe/vim-sleuth
  use({
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
  })

  use('tpope/vim-sleuth')
  use('tpope/vim-abolish')

  -- git integration
  use('ruanyl/vim-gh-line') -- gh links for text
  use({ 'tpope/vim-fugitive', config = require('plugins.fugitive') })
  use({
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitsigns').setup()
    end,
  })

  -- highlight yanked text
  use('machakann/vim-highlightedyank')

  -- Treesitter ast / highlighting
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    run = ':TSUpdate',
    config = require('plugins.treesitter'),
  })

  -- json navigation
  use({ 'theprimeagen/jvim.nvim', requires = { 'nvim-treesitter/nvim-treesitter' } })

  -- lsp refactoring
  use({
    'ThePrimeagen/refactoring.nvim',
    requires = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('refactoring').setup({})
    end,
  })

  -- Telescope
  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'ThePrimeagen/git-worktree.nvim',
      'ThePrimeagen/refactoring.nvim',
      'ThePrimeagen/harpoon',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
    },
    config = function()
      require('plugins.telescope')()
    end,
  })

  -- harpoon navigation
  use({
    'ThePrimeagen/harpoon',
    requires = { 'nvim-lua/plenary.nvim' },
    config = require('plugins.harpoon'),
  })

  -- snippets
  use({
    'L3MON4D3/LuaSnip',
    config = function()
      require('plugins.luasnip')
    end,
  })

  -- lsp ts setup
  use({
    'neovim/nvim-lspconfig',
    requires = {
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
  })

  -- lsp progress
  use({
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end,
  })

  -- cmp completion
  use({
    'hrsh7th/nvim-cmp',
    requires = {
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
  })

  -- lsp signatures
  use({
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  })

  -- status line and Color Scheme
  use({
    'folke/tokyonight.nvim',
    requires = {
      'nvim-lualine/lualine.nvim',
      'kyazdani42/nvim-web-devicons',
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
  })

  -- debugger
  use({
    'mfussenegger/nvim-dap',
    requires = {
      'rcarriga/nvim-dap-ui',
      'simrat39/rust-tools.nvim',
    },
    config = require('plugins.dap'),
  })

  -- use obsidian from nvim
  use({
    'epwalsh/obsidian.nvim',
    config = function()
      require('obsidian').setup({
        dir = '~/Documents/notes',
        completion = {
          nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
        },
      })
    end,
  })
end

-- automatically install and se up packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

-- https://github.com/wbthomason/packer.nvim#bootstrapping
local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  load_plugins(use)
  if packer_bootstrap then
    require('packer').sync()
  end
end)
