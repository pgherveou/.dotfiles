-- only enable keys
local keys = {
  {
    '<leader>l',
    function()
      require('rust-quick-tests').replay_last()
    end,
    desc = 'Replay last test',
  },
  {
    '<leader>gl',
    function()
      require('rust-quick-tests').snap_last()
    end,
    desc = 'Snap back to last test',
  },
}

if require('plugins.lsp.common').no_rust_lsp then
  vim.list_extend(keys, {
    {
      'K',
      function()
        require('rust-quick-tests').hover_actions()
      end,
      desc = 'Rust tests Hover actions',
    },
  })
end

return {
  'pgherveou/rust-quick-tests.nvim',
  -- enabled = require('plugins.lsp.common').no_rust_lsp,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  dev = true,
  lazy = true,
  config = function()
    require('rust-quick-tests').setup()
    vim.cmd('cnoreabbrev R RustQuick')
    require('dap').adapters['codelldb'] = require('utils.dap').get_codelldb_adapter()
  end,
  ft = { 'rust' },
  cmd = { 'RustQuick' },
  keys = keys,
}
