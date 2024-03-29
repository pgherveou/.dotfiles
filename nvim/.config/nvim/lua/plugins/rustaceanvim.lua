vim.g.rustaceanvim = function()
  return {
    -- Plugin configuration
    tools = {
      runnables = {
        use_telescope = true,
      },
      hover_actions = {
        replace_builtin_hover = true,
      },
      float_win_config = {
        auto_focus = true,
      },
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        local common = require('plugins.lsp.common')
        common.set_mappings(client, bufnr, {
          ['<leader>l'] = { cmd = ':RustLsp! runnables<CR>', desc = 'Run last runnable' },
          ['<leader>D'] = { cmd = ':RustLsp! debuggables<CR>', desc = 'Run last debuggable' },
          ['<leader>m'] = { cmd = ':RustLsp! expandMacro<CR>', desc = 'Expand macros' },
        })
      end,
      settings = {
        -- see https://rust-analyzer.github.io/manual.html#configuration
        ['rust-analyzer'] = {
          rust = {
            -- Use a separate target dir for Rust Analyzer. Helpful if you want to use Rust
            -- Analyzer and cargo on the command line at the same time.
            analyzerTargetDir = 'target/nvim-rust-analyzer',
          },
          server = {
            -- Improve stability
            extraEnv = {
              ['CHALK_OVERFLOW_DEPTH'] = '100000000',
              ['CHALK_SOLVER_MAX_SIZE'] = '100000000',
            },
          },
          cargo = {
            -- Check feature-gated code
            features = 'all',
            extraEnv = {
              -- Skip building WASM, there is never need for it here
              ['SKIP_WASM_BUILD'] = '1',
            },
          },
          -- diagnostics = {
          --   disabled = true,
          -- },
          procMacro = {
            -- enable = false,
            -- Don't expand some problematic proc_macros
            ignored = {
              ['async-trait'] = { 'async_trait' },
              ['napi-derive'] = { 'napi' },
              ['async-recursion'] = { 'async_recursion' },
              ['async-std'] = { 'async_std' },
            },
          },
          rustfmt = {
            -- Use nightly formatting.
            -- See the polkadot-sdk CI job that checks formatting for the current version used in
            -- polkadot-sdk.
            -- extraArgs = { '+nightly-2023-11-01' },
            -- extraArgs = { '+nightly' },
          },
        },
      },
    },
    -- DAP configuration
    dap = {
      adapter = require('utils.dap').get_codelldb_adapter(),
    },
  }
end

return {
  'mrcjkb/rustaceanvim',
  version = '^4', -- Recommended
  enabled = require('plugins.lsp.common').no_rust_lsp == false,
  ft = { 'rust' },
}
