return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  lazy = true,
  keys = {
    { '<leader>ca', ':CodeCompanionChat<CR>', desc = 'Open codecompanion chat' },
    { '<leader>f', ":'<,'>CodeCompanion /fix<CR>", mode = 'v',  desc = 'Open codecompanion chat' },
    { '<leader>e', ":'<,'>CodeCompanion /explain<CR>", mode = 'v',  desc = 'Open codecompanion chat' }

  },
  config = function()
    require('codecompanion').setup({

      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            env = {
              api_key = os.getenv('OPENAI_API_NVIM_KEY'),
            },
          })
        end,
      },
      -- strategies = {
      --   chat = {
      --     adapter = 'copilot',
      --   },
      --   inline = {
      --     adapter = 'copilot',
      --   },
      --   completion = {
      --     adapter = 'copilot',
      --   },
      --   diagnostics = {
      --     adapter = 'copilot',
      --   },
      -- },
    })
  end,
}
