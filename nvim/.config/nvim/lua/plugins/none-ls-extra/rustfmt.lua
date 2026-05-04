local h = require('null-ls.helpers')
local methods = require('null-ls.methods')

local FORMATTING = methods.internal.FORMATTING

-- get nightly rustfmt
-- local command = vim.fn.trim(vim.fn.system('rustup which rustfmt --toolchain nightly'))

local function read_edition(path)
  local ok, lines = pcall(io.lines, path)
  if not ok then return nil end
  for line in lines do
    local edition = line:match('^%s*edition%s*=%s*"([^"]+)"')
    if edition then return edition end
    if line:match('edition.-workspace%s*=%s*true') then
      return 'workspace'
    end
  end
  return nil
end

local function get_edition(bufname)
  local dir = bufname and vim.fs.dirname(bufname)
  if not dir or dir == '' then return '2024' end
  local found = vim.fs.find('Cargo.toml', { upward = true, path = dir, limit = math.huge })
  for _, path in ipairs(found) do
    local edition = read_edition(path)
    if edition and edition ~= 'workspace' then
      return edition
    end
  end
  return '2024'
end

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
    args = function(params)
      return { 'run', 'nightly', 'rustfmt', '--edition=' .. get_edition(params.bufname) }
    end,
    to_stdin = true,
  },
  factory = h.formatter_factory,
})
