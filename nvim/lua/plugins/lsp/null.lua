-- https://github.com/jose-elias-alvarez/null-ls.nvim
return function()
  local null = require('null-ls')
  local formatters = null.builtins.formatting
  local linters = null.builtins.diagnostics

  null.config({
    -- debug = true,
    sources = {
      formatters.eslint_d,
      formatters.rustfmt,
      formatters.gofmt,
      formatters.prettier,
      formatters.stylua.with({
        extra_args = {
          '--config-path',
          vim.fn.expand('~/Github/dotfiles/stylua.toml'),
        },
      }),
      linters.luacheck.with({
        args = {
          '--no-max-line-length',
          '--globals',
          'vim',
          '--formatter',
          'plain',
          '--codes',
          '--ranges',
          '--filename',
          '$FILENAME',
          '-',
        },
      }),
      linters.eslint_d.with({ timeout = 20000 }),
      linters.shellcheck,
    },
  })

  require('lspconfig')['null-ls'].setup({
    on_attach = function()
      vim.cmd([[
        augroup Format
            autocmd! * <buffer>
            autocmd BufWritePre <buffer> silent! lua vim.lsp.buf.formatting_sync()
        augroup END
      ]])
    end,
  })
end
