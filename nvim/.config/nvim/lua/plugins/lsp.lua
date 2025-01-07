local u = require('utils')
local common = require('plugins.lsp.common')

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
    common.set_mappings(client, bufnr)
  end

  local default_flags = { debounce_text_changes = 100 }
  local default_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = default_flags,
  }

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

  lspconfig.marksman.setup(default_config)

  lspconfig.lua_ls.setup(vim.tbl_extend('force', default_config, {
    settings = {
      Lua = {
        telemetry = { enable = false },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            vim.env.HOME .. '/.hammerspoon/Spoons/EmmyLua.spoon/annotations',
          },
        },
        diagnostics = {
          globals = { 'vim', 'hs' },
        },
      },
    },
  }))

  lspconfig.bashls.setup(default_config)
  lspconfig.golangci_lint_ls.setup(default_config)
  lspconfig.gopls.setup(vim.tbl_extend('force', default_config, {
    on_attach = function(client, bufnr)
      default_config.on_attach(client, bufnr)
      u.buf_nmap(bufnr, '<leader>t', ':GoTestFunc<CR>')
    end,
  }))

  -- lspconfig.jsonnet_ls.setup(default_config)
  lspconfig.pyright.setup(default_config)
  lspconfig.clangd.setup(default_config)
  lspconfig.tailwindcss.setup(default_config)
  lspconfig.ts_ls.setup(default_config)
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'nvimtools/none-ls.nvim',
    'b0o/schemastore.nvim',
    'ThePrimeagen/refactoring.nvim',
    'folke/neodev.nvim',
  },
  config = function()
    require('neodev').setup({})
    require('mason').setup()

    -- ensure these packages are installed with mason
    -- 'bashls', 'prettierd', 'clang-format', 'bacon', 'clangd', 'codelldb', 'codespell', 'eslint_d', 'golangci_lint_ls', 'jq', 'jsonls', 'lua_ls', 'luacheck', 'marksman', 'pyright', 'rust_analyzer', 'shellcheck', 'stylua', 'tailwindcss', 'taplo', 'ts_ls',
    require('mason-lspconfig').setup({ automatic_installation = false })
    setup_servers()
    require('plugins.none-ls-extra.common').setup(common.format_on_save)
  end,
}


