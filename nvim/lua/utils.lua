local get_map_options = function(custom_options)
  local options = { noremap = true, silent = true }
  if custom_options then
    options = vim.tbl_extend('force', options, custom_options)
  end
  return options
end

local M = {}

M.map = function(mode, target, source, opts)
  vim.api.nvim_set_keymap(mode, target, source, get_map_options(opts))
end

M.buf_map = function(mode, bufnr, target, source, opts)
  vim.api.nvim_buf_set_keymap(bufnr, mode, target, source, get_map_options(opts))
end
for _, mode in ipairs({ 'n', 'o', 'i', 'x', 't' }) do
  M[mode .. 'map'] = function(...)
    M.map(mode, ...)
  end
  M['buf_' .. mode .. 'map'] = function(...)
    M.buf_map(mode, ...)
  end
end

M.command = function(name, fn)
  vim.cmd(string.format('command! %s %s', name, fn))
end

M.lua_command = function(name, fn)
  M.command(name, 'lua ' .. fn)
end

M.warn = function(msg)
  vim.api.nvim_echo({ { msg, 'WarningMsg' } }, true, {})
end

return M
