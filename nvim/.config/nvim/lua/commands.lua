vim.api.nvim_create_user_command('ClearRegisters', function()
  local regs = vim.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '')
  for _, r in ipairs(regs) do
    vim.fn.setreg(r, {})
  end
end, {})

-- rename a file
vim.api.nvim_create_user_command('Rename', function()
  local old_name = vim.fn.expand('%')
  local new_name = vim.fn.input('New name: ', old_name, 'file')
  if new_name ~= '' then
    vim.fn.rename(old_name, new_name)
    vim.cmd('edit ' .. new_name)
  end
end, {})

-- delete a file
vim.api.nvim_create_user_command('Delete', function()
  local file = vim.fn.expand('%')
  local confirm = vim.fn.input('Delete ' .. file .. '? (y/N) ')
  if confirm == 'y' then
    vim.cmd('bd')
    vim.fn.delete(file)
  end
end, {})

-- reload the current file by calling :BufDel first
vim.api.nvim_create_user_command('BufReload', function()
  local current_file = vim.fn.expand('%')
  local current_position = vim.fn.getpos('.')

  -- disable close when last buffer is deleted

  vim.cmd(':bd')
  vim.cmd('edit ' .. current_file)
  vim.fn.setpos('.', current_position)
end, {})

-- set RUST_LOG to the specified value
vim.api.nvim_create_user_command('RustLog', function(opts)
  vim.fn.setenv('RUST_LOG', opts.fargs[1])
end, {
  nargs = 1,
  complete = function()
    return { 'info', 'warn', 'debug', 'trace' }
  end,
})

-- concat to RUST_LOG the provided value
vim.api.nvim_create_user_command('RustLogAdd', function(opts)
  local current = vim.fn.getenv('RUST_LOG')
  local new = opts.fargs[1]

  if current == '' then
    vim.fn.setenv('RUST_LOG', new)
    return
  end

  if string.find(current, new) then
    return
  end

  vim.fn.setenv('RUST_LOG', current .. ',' .. new)
  print(vim.fn.getenv('RUST_LOG'))
end, {
  nargs = 1,
  complete = function()
    return { 'pg=debug', 'runtime::contracts=debug' }
  end,
})

vim.api.nvim_create_user_command('ToggleRustBackTrace', function()
  if vim.fn.getenv('RUST_BACKTRACE') == '1' then
    vim.fn.setenv('RUST_BACKTRACE', nil)
  else
    vim.fn.setenv('RUST_BACKTRACE', '1')
  end
end, {})
