-- https://github.com/jose-elias-alvarez/null-ls.nvim
local null_ls = require('null-ls')
local builtins = null_ls.builtins
local Path = require('plenary.path')

local eslintConfig = {
  timeout = 20000,
  condition = function(utils)
    return utils.root_has_file({ '.eslintrc.js', '.eslintrc' })
  end,
}

local sources = {
  builtins.formatting.shfmt,
  builtins.formatting.rustfmt,
  builtins.diagnostics.codespell.with({
    extra_args = {
      '--ignore-words=' .. Path:new('~/.config/codespell/ignore-words.txt'):expand(),
    },
  }),
  builtins.formatting.gofmt,
  builtins.formatting.clang_format,
  builtins.formatting.prettierd.with({
    condition = function(utils)
      return utils.root_has_file({ '.prettierrc', '.prettierrc.js' })
    end,
  }),
  builtins.formatting.stylua.with({
    condition = function(utils)
      return utils.root_has_file({ 'stylua.toml', '.stylua.toml' })
    end,
  }),
  builtins.diagnostics.luacheck.with({
    condition = function(utils)
      return utils.root_has_file({ '.luacheckrc' })
    end,
    args = {
      '--formatter',
      'plain',
      '--codes',
      '--ranges',
      '--filename',
      '$FILENAME',
      '-',
    },
  }),
  builtins.code_actions.eslint_d.with(eslintConfig),
  builtins.diagnostics.eslint_d.with(eslintConfig),
  builtins.diagnostics.shellcheck,
}

local M = {}

M.setup = function(on_attach)
  null_ls.setup({
    -- debug = true,
    sources = sources,
    on_attach = on_attach,
    should_attach = function(bufnr)
      return vim.api.nvim_buf_line_count(bufnr) < 10000
    end,
  })
end

return M
