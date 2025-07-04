return {

  -- Surround text.
  'machakann/vim-sandwich',

  {
    'echasnovski/mini.nvim',
    version = false,
    enabled = false,
    config = function()
      require('mini.pairs').setup()
    end,
  },

  -- better buffer deletion
  'ojroques/nvim-bufdel',

  -- adjusts indentation based on filetype
  'tpope/vim-sleuth',

  -- install fatih/vim-go and install binaries if needed
  {
    'fatih/vim-go',
    build = ':GoUpdateBinaries',
    ft = { 'go' },
    config = function()
      vim.g.go_term_reuse = 1
      vim.g.go_term_enabled = 1
      vim.g.go_term_close_on_exit = 0
      vim.g.go_term_mode = 'split'
      vim.g.go_test_timeout = '5s'
    end,
  },

  -- handlebars syntax
  'mustache/vim-mustache-handlebars',

  -- see https://github.com/sheerun/vim-polyglot#language-packs
  -- for installing more language packs

  -- take screenshots
  {
    'narutoxy/silicon.lua',
    dependencies = 'nvim-lua/plenary.nvim',
    build = './install.sh',
    lazy = true,
    keys = {
      {
        '<leader>sn',
        function()
          require('silicon').visualise_api({ to_clip = true })
        end,
        mode = 'v',
        silent = true,
        desc = 'Screenshot selected text',
      },
    },
    config = function()
      local silicon = require('silicon')
      silicon.setup({})
    end,
  },

  -- search visually selected text
  'nelstrom/vim-visual-star-search',

  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup()
      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.ACTIVE, function(bufnr)
        return vim.api.nvim_buf_line_count(bufnr) < 5000
      end)
    end,
  },

  -- :S command and cr command for case coercing
  'tpope/vim-abolish',

  -- git integration
  -- {
  --   'lewis6991/gitsigns.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim' },
  --   config = function()
  --     require('gitsigns').setup()
  --   end,
  -- },

  -- highlight yanked text
  'machakann/vim-highlightedyank',

  -- lsp progress
  {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({
        notification = { -- NOTE: you're missing this outer table
          window = {
            winblend = 0, -- NOTE: it's winblend, not blend
          },
        },
      })
    end,
  },

  -- lsp signatures
  {
    'ray-x/lsp_signature.nvim',
    config = function()
      require('lsp_signature').setup()
    end,
  },
}
