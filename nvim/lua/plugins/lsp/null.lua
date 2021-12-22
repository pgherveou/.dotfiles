-- https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls = require('null-ls')
local builtins = null_ls.builtins

local sources = {
  builtins.formatting.shfmt,
  builtins.formatting.rustfmt,
  builtins.diagnostics.codespell.with({
    extra_args = {
      '--ignore-words=~/.config/codespell/ignore-words.txt',
    },
  }),
  builtins.formatting.gofmt,
  builtins.formatting.clang_format,
  builtins.formatting.prettier,
  builtins.formatting.stylua.with({
    extra_args = {
      '--config-path',
      vim.fn.expand('~/Github/dotfiles/stylua.toml'),
    },
  }),
  builtins.diagnostics.luacheck.with({
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
  builtins.code_actions.eslint_d.with({ timeout = 20000 }),
  builtins.diagnostics.eslint_d.with({ timeout = 20000 }),
  builtins.diagnostics.shellcheck,
}

local M = {}

M.setup = function(on_attach)
  null_ls.setup({
    --debug = true,
    sources = sources,
    on_attach = on_attach,
  })
end

return M
