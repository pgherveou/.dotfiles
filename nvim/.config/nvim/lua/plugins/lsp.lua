local u = require('utils')
local common = require('plugins.lsp.common')

local setup_servers = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
  capabilities.offsetEncoding = { 'utf-16' }

  -- most languages use a custom formatter to format the code
  local disable_formatting = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  local on_attach = function(client, bufnr)
    disable_formatting(client)
    common.set_mappings(client, bufnr)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end

  local on_attach_with_formatting = function(client, bufnr)
    common.set_mappings(client, bufnr)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end

  local default_flags = { debounce_text_changes = 150 }
  local default_config = {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = default_flags,
  }

  vim.lsp.config('jsonls', {
    flags = default_flags,
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
      },
    },
  })
  vim.lsp.enable('jsonls')

  vim.lsp.config('marksman', default_config)
  vim.lsp.enable('marksman')

  vim.lsp.config(
    'lua_ls',
    vim.tbl_extend('force', default_config, {
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
    })
  )
  vim.lsp.enable('lua_ls')

  vim.lsp.config(
    'bashls',
    vim.tbl_extend('force', default_config, {
      settings = {
        bashIde = {
          shellcheckArguments = '--exclude=SC2086'
        }
      }
    })
  )
  vim.lsp.enable('bashls')

  vim.lsp.config('golangci_lint_ls', default_config)
  vim.lsp.enable('golangci_lint_ls')

  vim.lsp.config(
    'gopls',
    vim.tbl_extend('force', default_config, {
      on_attach = function(client, bufnr)
        default_config.on_attach(client, bufnr)
        u.buf_nmap(bufnr, '<leader>t', ':GoTestFunc<CR>')
      end,
    })
  )
  vim.lsp.enable('gopls')

  -- vim.lsp.config('jsonnet_ls', default_config)
  -- vim.lsp.enable('jsonnet_ls')

  vim.lsp.config('pyright', default_config)
  vim.lsp.enable('pyright')

  vim.lsp.config('clangd', default_config)
  vim.lsp.enable('clangd')


  vim.lsp.config(
    'denols',
    vim.tbl_extend('force', default_config, {
      on_attach = on_attach_with_formatting,
      root_markers = { 'deno.json', 'deno.jsonc' },
    })
  )
  vim.lsp.enable('denols')

  vim.lsp.config(
    'ts_ls',
    vim.tbl_extend('force', default_config, {
      root_markers = { 'package.json' },
      single_file_support = false,
      root_dir = function(fname)
        local util = vim.lsp.config.util or require('lspconfig.util')
        local root = util.root_pattern('package.json')(fname)
        if root then
          -- Check if this is a Deno project
          local deno_json = vim.uv.fs_stat(root .. '/deno.json')
          local deno_jsonc = vim.uv.fs_stat(root .. '/deno.jsonc')
          if deno_json or deno_jsonc then
            return nil -- Don't start ts_ls in Deno projects
          end
          return root
        end
        return nil
      end,
    })
  )
  vim.lsp.enable('ts_ls')
end

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
    'nvimtools/none-ls.nvim',
    'b0o/schemastore.nvim',
    'ThePrimeagen/refactoring.nvim',
    'folke/neodev.nvim',
  },
  config = function()
    require('neodev').setup()
    require('mason').setup()

    -- ensure these packages are installed with mason
    -- 'bashls', 'prettierd', 'clang-format', 'bacon', 'clangd', 'codelldb', 'codespell', 'eslint_d', 'golangci_lint_ls', 'jq', 'jsonls', 'lua_ls', 'luacheck', 'marksman', 'pyright', 'rust_analyzer', 'shellcheck', 'stylua', 'tailwindcss', 'taplo', 'ts_ls',
    require('mason-lspconfig').setup({
      automatic_enable = false,
    })
    setup_servers()
    require('plugins.none-ls-extra.common').setup(common.format_on_save)
  end,
}
