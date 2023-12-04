vim.api.nvim_create_user_command('ClearRegisters', function()
  local regs = vim.split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '')
  for _, r in ipairs(regs) do
    vim.fn.setreg(r, {})
  end
end, {})

-- clear marks
vim.api.nvim_create_user_command('ClearMarks', function()
  vim.cmd('delmarks A-Z0-9')
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
vim.api.nvim_create_user_command('BufReload', function(opts)
  local current_file = vim.fn.expand('%')
  local current_position = vim.fn.getpos('.')
  -- disable close when last buffer is deleted
  local hidden = vim.o.hidden
  vim.o.hidden = true

  -- call :bd and forward the bang option
  vim.cmd(':bd' .. (opts.bang and '!' or ''))
  vim.cmd('edit ' .. current_file)
  vim.fn.setpos('.', current_position)

  -- restore hidden option
  vim.o.hidden = hidden
end, {
  bang = true,
  desc = 'Reload the current buffer',
})

-- set RUST_LOG to the specified value
vim.api.nvim_create_user_command('RustLog', function(opts)
  vim.fn.setenv('RUST_LOG', opts.fargs[1])
end, {
  nargs = 1,
  complete = function()
    return { 'info', 'warn', 'debug', 'trace' }
  end,
})

vim.api.nvim_create_user_command('RustExecArgs', function(opts)
  local args = table.concat(opts.fargs, ' ')
  vim.fn.setenv('RUST_EXECUTABLE_ARGS', args)
end, {
  nargs = '*',
})

vim.api.nvim_create_user_command('SetEnv', function(opts)
  vim.fn.setenv(opts.fargs[1], opts.fargs[2])
end, {
  nargs = '*',
  desc = 'Set an environment variable',
})

-- concat to RUST_LOG the provided value
vim.api.nvim_create_user_command('RustLogAdd', function(opts)
  local current = vim.fn.getenv('RUST_LOG')
  local new = opts.fargs[1]

  -- empty or nil
  if current == '' or current == vim.NIL then
    vim.fn.setenv('RUST_LOG', new)
    return
  end

  if string.find(current, new) then
    return
  end

  vim.fn.setenv('RUST_LOG', current .. ',' .. new)
end, {
  nargs = 1,
  complete = function()
    return { 'pg=debug', 'runtime::contracts=debug', 'xcm=trace' }
  end,
})

vim.api.nvim_create_user_command('ToggleRustBackTrace', function()
  if vim.fn.getenv('RUST_BACKTRACE') == '1' then
    vim.fn.setenv('RUST_BACKTRACE', nil)
  else
    vim.fn.setenv('RUST_BACKTRACE', '1')
  end
end, {})

-- create a command that kill all floating windows
vim.api.nvim_create_user_command('KillAllFloats', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then -- is_floating_window?
      vim.api.nvim_win_close(win, false) -- do not force
    end
  end
end, {})

-- create a command that add the current file to the quick fix list
vim.api.nvim_create_user_command('AddToQuickFix', function()
  local quick_fix_list = vim.fn.getqflist()
  local current_bufnr = vim.fn.bufnr('%')
  local current_filename = vim.fn.bufname(current_bufnr)
  local current_line = vim.fn.getline('.')

  local current_item =
    { bufnr = current_bufnr, filename = current_filename, lnum = vim.fn.line('.'), text = current_line }
  table.insert(quick_fix_list, current_item)
  vim.fn.setqflist(quick_fix_list, 'r')
end, {})

-- convert to hexdump
vim.api.nvim_create_user_command('Hexdump', function(opts)
  if opts.fargs[1] == 'revert' then
    vim.cmd('%!xxd -r')
  else
    vim.cmd('%!xxd')
  end
end, {
  nargs = '?',
  complete = function()
    return { 'revert' }
  end,
})

-- create a scratch buffer with the given filetype or markdown by default
vim.api.nvim_create_user_command('Scratch', function(opts)
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', opts.fargs[1] or 'markdown')
end, {
  nargs = '?',
})

-- toggle space and tab characters
vim.api.nvim_create_user_command('ToggleWhitespace', function()
  if vim.o.list then
    vim.o.list = false
  else
    vim.o.list = true
    vim.o.listchars = 'tab:▸ ,trail:·,extends:❯,precedes:❮'
  end
end, {})
