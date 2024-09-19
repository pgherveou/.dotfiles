local h = require('null-ls.helpers')
local methods = require('null-ls.methods')

local FORMATTING = methods.internal.FORMATTING

-- get nightly rustfmt
-- local command = vim.fn.trim(vim.fn.system('rustup which rustfmt --toolchain nightly'))

return h.make_builtin({
  name = 'rustfmt',
  command = 'rustup',
  meta = {
    url = 'https://github.com/rust-lang/rustfmt',
    description = 'A tool for formatting rust code according to style guidelines.',
    notes = {},
  },
  method = FORMATTING,
  filetypes = { 'rust' },
  generator_opts = {
    command = 'rustfmt',
    args = { 'run', 'nightly', 'rustfmt' },
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
