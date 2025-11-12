local function is_pr(word)
  local pr = word:match('%(#(%d+)%)')
  if pr then
    return pr
  end

  pr = word:match('#(%d+)')
  return pr or ''
end

local function open_file()
  local word = vim.fn.expand('<cWORD>')
  local pr = is_pr(word)
  if pr ~= '' then
    local cmd = string.format('!gh browse %s', pr)
    vim.cmd(cmd)
    return
  end

  local file = vim.fn.expand('%:~:.')
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line ~= end_line then
    file = file .. ':' .. start_line .. '-' .. end_line
  else
    file = file .. ':' .. start_line
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
