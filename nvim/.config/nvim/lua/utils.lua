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

--- Table based API for setting keybindings
-- @param map_table A nested table where the first key is the vim mode, the second key is the key to map, and the value is the function to set the mapping to
M.keymaps = function(map_table)
  for mode, mappings in pairs(map_table) do
    for keymap, options in pairs(mappings) do
      local cmd = options
      local keymap_opts = {}
      if type(options) == 'table' then
        cmd = options[1]
        keymap_opts = vim.tbl_deep_extend('force', options, keymap_opts)
        keymap_opts[1] = nil
      end
      vim.keymap.set(mode, keymap, cmd, keymap_opts)
    end
  end
end

return M
