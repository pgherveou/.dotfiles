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

-- toggle completion
vim.api.nvim_create_user_command('ToggleCompletion', function()
  vim.b.completion = not vim.b.completion
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

vim.api.nvim_create_user_command('DecToHex', function(opts)
  local input = opts.args
  local number
  local hex

  if input ~= '' then
    number = tonumber(input)
    if not number then
      vim.notify('Invalid decimal number: ' .. input, vim.log.levels.WARN)
      return
    end
    hex = string.format('0x%X', number)
    vim.api.nvim_paste(hex, true, -1) -- paste at cursor
  else
    -- No arg: work with number on current line
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_get_current_line()
    local before, match, after = line:match('^(.-)(%d+)(.-)$')

    if not match then
      vim.notify('No decimal number found on the current line', vim.log.levels.WARN)
      return
    end

    number = tonumber(match)
    hex = string.format('0x%X', number)
    local new_line = before .. hex .. after
    vim.api.nvim_buf_set_lines(0, row - 1, row, false, { new_line })
  end
end, {
  nargs = '?',
  desc = 'Convert a decimal number to hexadecimal (replaces number inline if no arg, else inserts at cursor)',
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

vim.api.nvim_create_user_command('YankMacro', function(opts)
  local register = opts.fargs[1] or 'q'
  local register_content = vim.fn.getreg(register)
  local macro = vim.fn.keytrans(register_content)
  vim.fn.setreg('+', macro)
  vim.fn.setreg('*', macro)
  vim.fn.setreg('"', macro)
end, {
  nargs = '*',
})

local macros = {
  -- replace text between < > with the result of rustfilt
  rustfilt = [[0f<ci><C-R>=system("rustfilt",getreg('"'))<CR><Esc>]],
  -- replace git and rev with path from patch
  cargo_patch = [["ayt<Space>f""bya"/\(<C-R>a<Space>=\|"<C-R>a"\)<CR>:s#git<Space>=<Space>".\{-}",<Space>rev<Space>=<Space>"\<BS>.\{-}"#path<Space>=<Space><C-R>b<Esc>]],
  -- compare left / right bench results
  cmp_bench = [[f:w"ayiw<C-L>"byiwA<Space><C-R>=printf("%.2f%%",1-(<C-R>a/(<C-R>b*1.0))*100)<CR><Esc><C-H>j0]],
}

vim.api.nvim_create_user_command('PutMacro', function(opts)
  local macro = macros[opts.fargs[1]] or vim.fn.getreg(opts.fargs[1])
  local register = opts.fargs[2] or 'q'
  local macro_content = vim.api.nvim_replace_termcodes(macro, true, true, true)
  -- print('Set register ' .. register .. ' with macro: ' .. macro)
  vim.fn.setreg(register, macro_content)
end, {
  nargs = '?',
  complete = function()
    local keys = {}
    for k, _ in pairs(macros) do
      table.insert(keys, k)
    end
    return keys
  end,
})

vim.api.nvim_create_user_command('Worktree', function(opts)
  local path = opts.fargs[1]
  local branch = opts.fargs[2]
  require('git-worktree').create_worktree(path, branch, 'origin')
end, {
  nargs = '*',
})

vim.api.nvim_create_autocmd('FocusLost', {
  pattern = '*',
  callback = function()
    local text = vim.fn.getreg('"')
    if text == '' then
      return
    end

    if vim.fn.has('mac') == 1 then
      -- vim.fn.system('nc localhost 8377', text)
      return
    end

    vim.fn.system('nc -N localhost 8377', text)
  end,
})

-- /cmd prdoc --audience runtime_dev --bump minor
vim.api.nvim_create_user_command('Prdoc', function(opts)
  local pr_number = string.gsub(vim.fn.system('gh pr view --json number --jq .number'), '\n', '')
  local root_dir = string.gsub(vim.fn.system('git rev-parse --show-toplevel'), '\n', '')
  local prdoc_file = root_dir .. '/prdoc/pr_' .. pr_number .. '.prdoc'

  if opts.fargs[1] == 'check' then
    local res = vim.fn.system('cd ' .. root_dir .. ' && RUST_LOG=debug prdoc check -n' .. pr_number)
    if vim.v.shell_error == 0 then
      print('prdoc is valid')
    else
      print(res)
    end
    return
  end

  if vim.fn.filereadable(prdoc_file) == 0 then
    vim.fn.system('cd ' .. root_dir .. ' && prdoc generate ' .. pr_number)
  end

  vim.cmd('edit ' .. prdoc_file)
end, {
  nargs = '?',
  complete = function()
    return { 'check' }
  end,
})

-- vim regex cheat sheet:
-- .\{-} => non greedy match
-- <  => beginning of a word
-- \w =>  a single letter
-- \u =>  turn to uppercase
