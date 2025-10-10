return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  lazy = true,
  keys = {
    { '<leader>ca', ':CodeCompanionChat<CR>', mode = { 'n', 'v' }, noremap = true, desc = 'Open codecompanion chat' },
    {
      '<leader>cm',
      ':CodeCompanionActions<CR>',
      mode = { 'n', 'v' },
      noremap = true,
      desc = 'Open codecompanion menu',
    },
    { '<leader>f', ':\'<,\'>CodeCompanion /fix<CR>', mode = 'v', desc = 'Open codecompanion chat' },
    { '<leader>e', ':\'<,\'>CodeCompanion /explain<CR>', mode = 'v', desc = 'Open codecompanion chat' },
  },
  config = function()
    require('codecompanion').setup({
      -- display = {
      --   action_palette = {
      --     provider = 'telescope',
      --   },
      -- },

      -- opts = {
      --   log_level = 'ERROR', -- TRACE|DEBUG|ERROR|INFO
      -- },
      adapters = {
        http = {
          openai = function()
            return require('codecompanion.adapters').extend('openai', {
              env = {
                api_key = os.getenv('OPENAI_API_NVIM_KEY'),
              },
            })
          end,
        },
      },
      strategies = {
        chat = {
          adapter = 'openai',
        },
        inline = {
          adapter = 'openai',
        },
        completion = {
          adapter = 'openai',
        },
        diagnostics = {
          adapter = 'openai',
        },
      },
    })
  end,
}
