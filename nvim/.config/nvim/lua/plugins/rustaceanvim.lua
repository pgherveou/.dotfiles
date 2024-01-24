vim.g.rustaceanvim = function()
  local mason_registry = require('mason-registry')
  local codelldb = mason_registry.get_package('codelldb')
  local extension_path = codelldb:get_install_path() .. '/extension/'
  local codelldb_path = extension_path .. 'adapter/codelldb'

  -- use .dylib if running on macos .so if running on linux
  local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  if vim.fn.has('mac') == 1 then
    liblldb_path = liblldb_path .. '.dylib'
  else
    liblldb_path = liblldb_path .. '.so'
  end

  local cfg = require('rustaceanvim.config')

  return {
    -- Plugin configuration
    tools = {
      runnables = {
        use_telescope = true,
      },
      inlay_hints = {
        show_parameter_hints = true,
        parameter_hints_prefix = '',
        other_hints_prefix = '',
      },
    },
    -- LSP configuration
    server = {
      on_attach = function(client, bufnr)
        require('plugins.lsp.common').set_mappings(client, bufnr, {
          ['K'] = {
            cmd = ':RustLsp hover actions<CR>',
            desc = 'Display hover actions',
          },
          ['<leader>l'] = { cmd = ':RustLsp runnables last<CR>', desc = 'Run last runnable' },
          ['<leader>D'] = { cmd = ':RustLsp debuggable last<CR>', desc = 'Run last debuggable' },
        })
      end,
      settings = {
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
          procMacro = {
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
            extraArgs = { '+nightly' },
          },
        },
      },
    },
    -- DAP configuration
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end

local enabled = true
if vim.fn.getenv('NO_LSP') == '1' then
  enabled = false
end

return {
  'mrcjkb/rustaceanvim',
  version = '^3', -- Recommended
  enabled = enabled,
  ft = { 'rust' },
}
