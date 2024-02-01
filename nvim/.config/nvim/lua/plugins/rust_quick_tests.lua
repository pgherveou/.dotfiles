return {
  'pgherveou/rust-quick-tests.nvim',
  enabled = vim.fn.getenv('NO_LSP') == '1',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  dev = true,
  config = true,
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
