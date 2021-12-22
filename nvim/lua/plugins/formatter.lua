local M = {}

local function getFileName(url)
  return url:match('^.+/(.+)$')
end

M.bzl_formatter = function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local args = { '-lint', 'fix', '--warnings', 'all', '--type' }

  local filename = getFileName(vim.api.nvim_buf_get_name(0))
  if string.find(filename, 'BUILD') then
    table.insert(args, 'build')
  elseif string.find(filename, 'WORKSPACE') then
    table.insert(args, 'workspace')
  else
    table.insert(args, 'bzl')
  end

  local Job = require('plenary.job')
  local s, jobOrErr = pcall(Job.new, Job, {
    command = 'buildifier',
    args = args,
    writer = lines,
  })

  if s == false then
    vim.api.nvim_err_writeln(jobOrErr)
    return
  end

  local job = jobOrErr
  local status, errOrResult = pcall(Job.sync, job)

  if status == false then
    vim.api.nvim_err_writeln(errOrResult)
    return
  end

  if job.code ~= 0 then
    local errors = job:stderr_result()
    for _, error in ipairs(errors) do
      vim.api.nvim_err_writeln(error)
    end
    return
  end

  local all_lines = {}
  local res = job:result()

  for _, line in ipairs(res) do
    local new_lines = vim.split(line, '\n')
    for _, new_line in ipairs(new_lines) do
      table.insert(all_lines, new_line)
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, all_lines)
end

return M
