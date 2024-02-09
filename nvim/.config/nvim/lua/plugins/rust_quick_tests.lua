return {
  'pgherveou/rust-quick-tests.nvim',
  enabled = vim.fn.getenv('NO_LSP') == '1',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  dev = true,
  config = function()
    require('rust-quick-tests').setup()
    require('dap').adapters['codelldb'] = require('utils.dap').get_codelldb_adapter()
  end,
  ft = { 'rust' },
  cmd = { 'RustQuick' },
  keys = {
    {
      'K',
      function()
        require('rust-quick-tests').hover_actions()
      end,
      desc = 'Rust tests Hover actions',
    },
    {
      '<leader>l',
      function()
        require('rust-quick-tests').replay_last()
      end,
      desc = 'Replay last test',
    },
  },
}
