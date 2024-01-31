return {
  'pgherveou/rust-quick-tests.nvim',
  enabled = vim.fn.getenv('NO_LSP') == '1',
  dev = true,
  ft = { 'rust' },
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
