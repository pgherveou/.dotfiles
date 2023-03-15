return {
  'simrat39/symbols-outline.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = true,
  cmd = 'SymbolsOutline',
  keys = {
    { 'gs', ':SymbolsOutline<CR>', desc = 'Toggle Symbols outline' },
  },
  config = function()
    require('symbols-outline').setup()
  end,
}
