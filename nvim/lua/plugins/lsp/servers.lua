-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local config_servers = function()
  local set_formatting_capabilities = function(client, value)
    client.resolved_capabilities.document_formatting = value
    client.resolved_capabilities.document_range_formatting = value
  end

  -- Set LSP capabilities.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  local commonConfig = {
    capabilities = capabilities,
    on_attach = function(client)
      set_formatting_capabilities(client, false)
    end,
  }

  return {
    gopls = commonConfig,
    golangci_lint_ls = commonConfig,
    ccls = commonConfig,
    rust_analyzer = commonConfig,
    tsserver = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        local ts_utils = require('nvim-lsp-ts-utils')

        ts_utils.setup({
          enable_import_on_completion = true,
          eslint_bin = 'eslint_d',
        })
        ts_utils.setup_client(client)
        set_formatting_capabilities(client, false)

        local opts = { silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs', ':TSLspOrganize<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', ':TSLspImportAll<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', ':TSLspRenameFile<CR>', opts)
      end,
    },
  }
end

return function()
  -- Debugging
  -- vim.lsp.set_log_level("debug")

  local lspconfig = require('lspconfig')
  local servers = config_servers()

  -- Initiate and setup all LSP servers (excluding null-ls).
  for server, config in pairs(servers) do
    lspconfig[server].setup(config)
  end

  -- mappings
  vim.cmd([[
  " General.
  nnoremap <silent> <Leader>f :lua vim.lsp.buf.formatting()<CR>
  nnoremap <silent> K :ShowDocumentation<CR>

  nnoremap <silent> gd :LspDef<CR>
  nnoremap <silent> gr :LspRename<CR>
  nnoremap <silent> gy :LspTypeDef<CR>
  nnoremap <silent> K  :LspHover<CR>
  nnoremap <silent> [a ":LspDiagPrev<CR>
  nnoremap <silent> ]a :LspDiagNext<CR>
  nnoremap <silent> ga :LspCodeAction<CR>
  map <C-x><C-x> <cmd> LspSignatureHelp<CR>

  " Diagnostics.
  nnoremap <silent> gl :lua vim.diagnostic.open_float(0, {scope = 'line', header = false})<CR>
  nnoremap <silent> <Leader>lj :lua vim.diagnostic.goto_next({float = false})<CR>
  nnoremap <silent> <Leader>lk :lua vim.diagnostic.goto_prev({float = false})<CR>

  " Commands.
  command! LspDef lua vim.lsp.buf.definition()
  command! LspFormatting lua vim.lsp.buf.formatting()
  command! LspCodeAction lua vim.lsp.buf.code_action()
  command! LspHover lua vim.lsp.buf.hover()
  command! LspRename lua vim.lsp.buf.rename()
  command! LspRefs lua vim.lsp.buf.references()
  command! LspTypeDef lua vim.lsp.buf.type_definition()
  command! LspImplementation lua vim.lsp.buf.implementation()
  command! LspDiagPrev lua vim.lsp.diagnostic.goto_prev()
  command! LspDiagNext lua vim.lsp.diagnostic.goto_next()
  command! LspDiagLine lua vim.lsp.diagnostic.show_line_diagnostics()
  command! LspSignatureHelp lua vim.lsp.buf.signature_help()

  ]])
end
