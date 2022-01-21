local u = require('utils')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local set_common_mappings = function(client, bufnr)
  u.buf_nmap(bufnr, '<Leader>f', ':lua vim.lsp.buf.formatting()<CR>')
  u.buf_nmap(bufnr, 'K', ':ShowDocumentation<CR>')

  u.buf_nmap(bufnr, 'gd', ':LspDef<CR>')
  u.buf_nmap(bufnr, 'gr', ':LspRename<CR>')
  u.buf_nmap(bufnr, 'gy', ':LspTypeDef<CR>')
  u.buf_nmap(bufnr, 'K', ':LspHover<CR>')
  u.buf_nmap(bufnr, '[a', '":LspDiagPrev<CR>')
  u.buf_nmap(bufnr, ']a', ':LspDiagNext<CR>')
  u.buf_nmap(bufnr, 'ga', ':Telescope lsp_code_actions<CR>')
  u.buf_nmap(bufnr, 'go', ':Telescope lsp_references<CR>')
  u.buf_nmap(bufnr, 'gi', ':LspDiagLine<CR>')
  u.buf_imap(bufnr, '<C-x><C-x>', '<cmd> LspSignatureHelp<CR>')

  u.lua_command('LspDef', 'vim.lsp.buf.definition()')
  u.lua_command('LspFormatting', 'vim.lsp.buf.formatting()')
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

  if client.resolved_capabilities.document_formatting then
    vim.cmd([[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_sync()
      augroup END
    ]])
  end
  require('illuminate').on_attach(client)
end

local setup_servers = function()
  local lspconfig = require('lspconfig')
  local lsp_status = require('lsp-status')
  lsp_status.register_progress()

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
  capabilities.offsetEncoding = { 'utf-16' }

  -- most languages use a custom formatter to format the code
  local disable_formatting = function(client)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end

  local on_attach = function(client, bufnr)
    lsp_status.on_attach(client, bufnr)
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
  require('rust-tools').setup({
    server = {
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

  lspconfig.bashls.setup(default_config)
  lspconfig.gopls.setup(default_config)
  lspconfig.golangci_lint_ls.setup(default_config)

  lspconfig.clangd.setup(default_config)
  -- lspconfig.ccls.setup(default_config)

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

      u.buf_nmap(bufnr, 'gs', ':TSLspOrganize<CR>')
      u.buf_nmap(bufnr, 'gi', ':TSLspImportAll<CR>')
      u.buf_nmap(bufnr, 'gi', ':TSLspRenameFile<CR>')
    end,
  })
end

return function()
  -- Debugging
  -- vim.lsp.set_log_level("debug")
  setup_servers()
  require('plugins.lsp.null').setup(set_common_mappings)
end
