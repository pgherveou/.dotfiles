-- only enable keys
local keys = {
  {
    '<leader>l',
    function()
      require('quick-tests').replay_last()
    end,
    desc = 'Replay last test',
  },
  {
    '<leader>gl',
    function()
      require('quick-tests').snap_last()
    end,
    desc = 'Snap back to last test',
  },
}

vim.list_extend(keys, {
  {
    'T',
    function()
      require('quick-tests').hover_actions()
    end,
    desc = 'Rust tests Hover actions',
  },
})

return {
  'pgherveou/quick-tests.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  dev = true,
  lazy = true,
  config = function()
    require('quick-tests').setup()
    vim.cmd('cnoreabbrev R RustQuick')
    require('dap').adapters['codelldb'] = require('utils.dap').get_codelldb_adapter()
  end,
  ft = { 'rust', 'typescript' },
  cmd = { 'RustQuick' },
  keys = keys,
}
