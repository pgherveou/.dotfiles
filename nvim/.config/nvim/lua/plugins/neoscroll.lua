return {
  'karb94/neoscroll.nvim',
  event = 'VeryLazy',
  config = function()
    require('neoscroll').setup({ mappings = { '<C-u>', '<C-d>' } })
  end,
}
