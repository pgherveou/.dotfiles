local M = {}

M.get_codelldb_adapter = function()
  local mason_registry = require('mason-registry')
  local codelldb = mason_registry.get_package('codelldb')
  local extension_path = codelldb:get_install_path() .. '/extension/'
  local codelldb_path = extension_path .. 'adapter/codelldb'

  -- use .dylib if running on macos .so if running on linux
  local liblldb_path = extension_path .. 'lldb/lib/liblldb'
  if vim.fn.has('mac') == 1 then
    liblldb_path = liblldb_path .. '.dylib'
  else
    liblldb_path = liblldb_path .. '.so'
  end

  return {
    type = 'server',
    port = '${port}',
    host = '127.0.0.1',
    executable = {
      command = codelldb_path,
      args = { '--liblldb', liblldb_path, '--port', '${port}' },
    },
  }
end

return M
