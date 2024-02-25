-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
local null_ls = require('null-ls')
local builtins = null_ls.builtins
local Path = require('plenary.path')

-- [null-ls] You required a deprecated builtin (formatting/rustfmt.lua), which will be removed in March.
-- Please migrate to alternatives: https://github.com/nvimtools/none-ls.nvim/issues/58
-- [null-ls] You required a deprecated builtin (diagnostics/luacheck.lua), which will be removed in March.

local sources = {
  builtins.formatting.shfmt,
  builtins.formatting.markdownlint,
  builtins.formatting.sql_formatter,
  builtins.formatting.gofmt,
  builtins.diagnostics.codespell.with({
    disabled_filetypes = { 'log' },
    extra_args = {
      '--ignore-words=' .. Path:new('~/.config/codespell/ignore-words.txt'):expand(),
    },
  }),
  builtins.formatting.clang_format.with({
    disabled_filetypes = { 'java' },
  }),
  builtins.formatting.prettierd.with({
    condition = function(utils)
      return utils.root_has_file({ '.prettierrc', '.prettierrc.js', '.prettierrc.json' })
    end,
  }),
  builtins.formatting.stylua.with({
    condition = function(utils)
      return utils.root_has_file({ 'stylua.toml', '.stylua.toml' })
    end,
  }),
  require('plugins.none-ls-extra.rustfmt').with({
    condition = function()
      return require('plugins.lsp.common').no_rust_lsp
    end,
    extra_args = { '--edition=2021' },
  }),
  require('plugins.none-ls-extra.luacheck').with({
    condition = function(utils)
      return utils.root_has_file({ '.luacheckrc' })
    end,
  }),
  require('plugins.none-ls-extra.shellcheck').with({
    condition = function(utils)
      return utils.root_has_file({ '.shellcheckrc' })
    end,
  }),
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
