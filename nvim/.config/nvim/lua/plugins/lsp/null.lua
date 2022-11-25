-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
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
  builtins.formatting.rustfmt.with({
    extra_args = function(params)
      local cargo_toml = Path:new(params.root .. '/' .. 'Cargo.toml')

      if cargo_toml:exists() and cargo_toml:is_file() then
        for _, line in ipairs(cargo_toml:readlines()) do
          local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
          if edition then
            return { '--edition=' .. edition }
          end
        end
      end
      -- default edition when we don't find `Cargo.toml` or the `edition` in it.
      return { '--edition=2021' }
    end,
  }),
  builtins.diagnostics.codespell.with({
    disabled_filetypes = { 'log' },
    extra_args = {
      '--ignore-words=' .. Path:new('~/.config/codespell/ignore-words.txt'):expand(),
    },
  }),
  builtins.formatting.gofmt,
  builtins.formatting.clang_format.with({
    disabled_filetypes = { 'java' },
  }),
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
  builtins.diagnostics.flake8,
  -- builtins.diagnostics.pylint,
  builtins.formatting.autopep8,
  builtins.diagnostics.mypy,
  builtins.formatting.sql_formatter,
  builtins.code_actions.eslint_d.with(eslintConfig),
  builtins.diagnostics.eslint_d.with(eslintConfig),
  builtins.diagnostics.shellcheck.with({
    condition = function(utils)
      return utils.root_has_file({ '.shellcheckrc' })
    end,
  }),
}

local M = {}

M.setup = function()
  null_ls.setup({
    -- debug = true,
    sources = sources,
    should_attach = function(bufnr)
      return vim.api.nvim_buf_line_count(bufnr) < 10000
    end,
  })
end

return M
