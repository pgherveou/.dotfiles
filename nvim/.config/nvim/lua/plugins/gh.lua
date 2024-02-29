local function is_pr()
  local word = vim.fn.expand('<cWORD>')
  local pattern = '#%d+'
  if string.match(word, pattern) then
    return string.sub(word, 2)
  else
    return ''
  end
end

local function open_file()
  local file = vim.fn.expand('%:~:.')
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line ~= end_line then
    file = file .. ':' .. start_line .. '-' .. end_line
  else
    file = file .. ':' .. start_line
  end

  local pr = is_pr()
  if pr ~= '' then
    local cmd = string.format('!gh browse %s', pr)
    vim.cmd(cmd)
    return
  end

  local branch = vim.fn.systemlist('git branch --show-current')[1]
  local cmd = string.format('!gh browse %s --branch %s', file, branch)
  vim.cmd(cmd)
end

return {
  'pgherveou/gh.nvim',
  dev = true,
  lazy = true,
  keys = {
    {
      '<leader>gh',
      function()
        open_file()
      end,
      mode = { 'n', 'v' },
      desc = 'Open file in github',
    },
  },
  config = function() end,
}
