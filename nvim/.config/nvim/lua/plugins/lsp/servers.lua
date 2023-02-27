local u = require('utils')

-- lsp commands
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

-- default lsp mappings
local default_lsp_mappings = {
  ['gs'] = { cmd = ':SymbolsOutline<CR>', desc = 'Display Symbols outline' },
  ['gd'] = { cmd = ':LspDef<CR>', desc = 'Go to definition' },
  ['gf'] = { cmd = ':LspRefs<CR>', desc = 'Go to references' },
  ['gr'] = { cmd = ':LspRename<CR>', desc = 'Rename symbol' },
  ['gy'] = { cmd = ':LspTypeDef<CR>', desc = 'Go to type definition' },
  ['K'] = { cmd = ':LspHover<CR>', desc = 'Display hover informations' },
  ['H'] = { cmd = ':LspSignatureHelp<CR>', desc = 'Display signature' },
  ['[a'] = { cmd = ':LspDiagPrev<CR>', desc = 'Go to previous diagnostic' },
  [']a'] = { cmd = ':LspDiagNext<CR>', desc = 'Go to next diagnostic' },
  ['ga'] = { cmd = ':lua vim.lsp.buf.code_action()<CR>', desc = 'Display code actions' },
  ['gl'] = { cmd = ':LspDiagLine<CR>', desc = 'Display diagnostic line' },
  ['go'] = { cmd = ':Telescope lsp_references<CR>', desc = 'Display lsp references' },
}

local format_on_save = function(client)
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
      augroup lsp_buf_format
        au! BufWritePre <buffer>
        autocmd BufWritePre <buffer> :lua vim.lsp.buf.format()
      augroup END
    ]])
  end
end

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local set_mappings = function(client, bufnr, nmap_mappings)
  local mappings = vim.tbl_extend('force', default_lsp_mappings, nmap_mappings or {})
  for key, item in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, 'n', key, item.cmd, { desc = item.desc, noremap = true, silent = true })
  end

  format_on_save(client)
  require('illuminate').on_attach(client)
end

local setup_servers = function()
  local lspconfig = require('lspconfig')
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.offsetEncoding = { 'utf-16' }

  -- most languages use a custom formatter to format the code
  local disable_formatting = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local on_attach = function(client, bufnr)
    disable_formatting(client)
    set_mappings(client, bufnr)
  end

  local default_flags = { debounce_text_changes = 100 }
  local default_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = default_flags,
  }

  -- setup rust via rust-tools
  -- local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/'
  -- local codelldb_path = extension_path .. 'adapter/codelldb'
  -- local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

  local mason_registry = require('mason-registry')
  local codelldb = mason_registry.get_package('codelldb')
  local extension_path = codelldb:get_install_path() .. '/extension/'
  local codelldb_path = extension_path .. 'adapter/codelldb'
  local liblldb_path = extension_path .. 'lldb/lib/liblldb.dylib'

  require('rust-tools').setup({
    dap = {
      adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path),
    },
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
        -- disable_formatting(client)
        set_mappings(client, bufnr, {
          ['K'] = {
            cmd = ':lua require("rust-tools").hover_actions.hover_actions()<CR>',
            desc = 'Display hover actions',
          },
          ['<leader>t'] = { cmd = ':RustTest<CR>', desc = 'Run tests' },
          ['<leader>gt'] = { cmd = ':RustTest<CR>', desc = 'Run tests' },
        })
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

  lspconfig.lua_ls.setup(default_config)

  lspconfig.bashls.setup(default_config)
  lspconfig.golangci_lint_ls.setup(default_config)
  lspconfig.gopls.setup(vim.tbl_extend('force', default_config, {
    on_attach = function(client, bufnr)
      default_config.on_attach(client, bufnr)
      u.buf_nmap(bufnr, '<leader>t', ':GoTestFunc<CR>')
    end,
  }))

  lspconfig.jsonnet_ls.setup(default_config)
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
  require('neodev').setup({})
  require('mason').setup()
  require('mason-lspconfig').setup({ automatic_installation = true })
  setup_servers()
  require('plugins.lsp.null').setup(format_on_save)
end
