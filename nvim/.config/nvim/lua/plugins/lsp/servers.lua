local u = require('utils')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local set_common_mappings = function(client, bufnr)
  u.buf_nmap(bufnr, 'K', ':ShowDocumentation<CR>')
  u.buf_nmap(bufnr, 'gs', ':SymbolsOutline<CR>')

  u.buf_nmap(bufnr, 'gd', ':LspDef<CR>')
  u.buf_nmap(bufnr, 'gf', ':LspRefs<CR>')
  u.buf_nmap(bufnr, 'gr', ':LspRename<CR>')
  u.buf_nmap(bufnr, 'gy', ':LspTypeDef<CR>')
  u.buf_nmap(bufnr, 'K', ':LspHover<CR>')
  u.buf_nmap(bufnr, '[a', '":LspDiagPrev<CR>')
  u.buf_nmap(bufnr, ']a', ':LspDiagNext<CR>')
  u.buf_nmap(bufnr, 'ga', ':lua vim.lsp.buf.code_action()<CR>')
  u.buf_nmap(bufnr, 'gl', ':LspDiagLine<CR>')
  u.buf_nmap(bufnr, 'go', ':Telescope lsp_references<CR>')
  u.buf_imap(bufnr, '<C-x><C-x>', '<cmd> LspSignatureHelp<CR>')

  u.lua_command('LspDef', 'vim.lsp.buf.definition()')
  u.lua_command('LspFormatting', 'vim.lsp.buf.format()')
  u.lua_command('LspCodeAction', 'vim.lsp.buf.code_action()')
  u.lua_command('LspHover', 'vim.lsp.buf.hover()')
  u.lua_command('LspRename', 'vim.lsp.buf.rename()')
  u.lua_command('LspRefs', 'vim.lsp.buf.references()')
  u.lua_command('LspTypeDef', 'vim.lsp.buf.type_definition()')
  u.lua_command('LspImplementation', 'vim.lsp.buf.implementation()')
  u.lua_command('LspDiagPrev', 'vim.diagnostic.goto_prev()')
  u.lua_command('LspDiagNext', 'vim.diagnostic.goto_next()')
  u.lua_command('LspDiagLine', 'vim.diagnostic.open_float()')
  u.lua_command('LspSignatureHelp', 'vim.lsp.buf.signature_help()')
  u.lua_command('LspDiagQuickfix', 'vim.diagnostic.setqflist()')

  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.format()
      augroup END
    ]])
  end
  require('illuminate').on_attach(client)
end

local setup_servers = function()
  local lspconfig = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  capabilities.offsetEncoding = { 'utf-16' }

  -- most languages use a custom formatter to format the code
  local disable_formatting = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local on_attach = function(client, bufnr)
    disable_formatting(client)
    set_common_mappings(client, bufnr)
  end

  local default_flags = { debounce_text_changes = 100 }
  local default_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = default_flags,
  }

  -- setup rust via rust-tools
  local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'
  require('rust-tools').setup({
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    },
    server = {
      settings = {
        ['rust-analyzer'] = {
          checkOnSave = {
            command = 'clippy',
          },
        },
      },
      cargo = {
        allFeatures = true,
      },
      flags = default_flags,
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        u.buf_nmap(bufnr, '<leader>t', ':RustTest<CR>')
      end,
    },
  })

  lspconfig.jsonls.setup({
    flags = default_flags,
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
      },
    },
  })

  lspconfig.bashls.setup(default_config)
  lspconfig.golangci_lint_ls.setup(default_config)
  lspconfig.gopls.setup(vim.tbl_extend('force', default_config, {
    on_attach = function(client, bufnr)
      default_config.on_attach(client, bufnr)
      u.buf_nmap(bufnr, '<leader>t', ':GoTestFunc<CR>')
    end,
  }))

  lspconfig.pyright.setup(default_config)
  lspconfig.clangd.setup(default_config)
  lspconfig.tailwindcss.setup(default_config)
  lspconfig.tsserver.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      local ts_utils = require('nvim-lsp-ts-utils')

      ts_utils.setup({
        enable_import_on_completion = true,
        eslint_bin = 'eslint_d',
      })
      ts_utils.setup_client(client)

      u.buf_nmap(bufnr, 'gI', ':TSLspImportAll<CR>')
      u.buf_nmap(bufnr, 'gR', ':TSLspRenameFile<CR>')
    end,
  })
end

return function()
  -- Debugging
  -- vim.lsp.set_log_level("debug")
  require('mason').setup()
  require('mason-lspconfig').setup({ automatic_installation = true })
  setup_servers()
  require('plugins.lsp.null').setup(set_common_mappings)
end
