local function toggle_fugitive_window()
  -- check if there is a buffer with filetype fugitive
  local fugitive_buffer = vim.fn.bufnr('fugitive://')
  -- if there is no buffer with filetype fugitive, or if the buffer is not visible then open it vertically
  if fugitive_buffer == -1 or vim.fn.bufwinnr(fugitive_buffer) == -1 then
    vim.cmd('vertical G')
    -- if there is a buffer with filetype fugitive, close it
  else
    vim.cmd('bd' .. fugitive_buffer)
  end
end

local function stagedHunksQuickfixList()
  local ignored_files = { 'Cargo.lock' }
  vim.fn.system('git diff --cached > /tmp/staged.diff')
  local lines = vim.fn.readfile('/tmp/staged.diff')

  local file_pattern = '^+++ b/'
  local mapped_lines = {}
  for line_number, line in ipairs(lines) do
    if line:match(file_pattern) then
      local filepath = line:sub(#file_pattern)
      local filename = vim.fn.fnamemodify(filepath, ':t')
      if not vim.tbl_contains(ignored_files, filename) then
        table.insert(mapped_lines, { filename = filepath, line_number = line_number })
      end
    end
  end

  local qf_list = {}
  local unified_diff_pattern = '^@@ %-%d+,%d+ %+(%d+),(%d+) @@'
  for _, line in ipairs(mapped_lines) do
    local line_number = line.line_number
    local next_line_number = mapped_lines[1 + _] and mapped_lines[1 + _].line_number or #lines

    local index = line_number + 1
    while index < next_line_number do
      local lnum, len = lines[index]:match(unified_diff_pattern)
      if lnum then
        local end_lnum = lnum + len
        table.insert(
          qf_list,
          { filename = line.filename, lnum = lnum, end_lnum = end_lnum, text = 'Staged change: ' .. line.filename }
        )
      end
      index = index + 1
    end
  end

  -- Set the quickfix list and open it
  vim.fn.setqflist(qf_list)
  vim.cmd('copen')
end

-- stagedHunksQuickfixList()
-- bind leader R to source the current file
-- vim.api.nvim_set_keymap('n', '<leader>R', ':source %<cr>', { noremap = true, silent = true })

local function main_diff_split()
  local remotes = vim.split(vim.fn.system('git remote'), '\n', { trimempty = true })
  for _, remote in ipairs(remotes) do
    local main_branch = vim.fn.system('git symbolic-ref --short refs/remotes/' .. remote .. '/HEAD')
    if vim.v.shell_error == 0 then
      vim.cmd('Gvdiffsplit ' .. main_branch .. ':%')
      return
    end
  end
  vim.notify('No main branch found', vim.log.levels.WARN)
end

return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  cmd = { 'GlLog', 'Gclog', 'Gvdiffsplit' },
  keys = {
    { '<leader>gs', toggle_fugitive_window, desc = '[Git] status window' },
    { '<leader>gd', ':Gvdiff  !~1<cr>', desc = '[Git] diff file' },
    { '<leader>gm', main_diff_split, desc = '[Git] vertival diff split for the current file and the main branch' },
    { '<leader>gb', ':G blame<cr>', desc = '[Git] blame' },
    { '<leader>gj', ':diffget //3<cr>', desc = '[Git] Pick diffget 3' },
    { '<leader>gf', ':diffget //2<cr>', desc = '[Git] Pick diffget 2' },
    { '<leader>grc', ':G rebase --continue<cr>', desc = '[Git] Continue rebase' },
    { '<leader>gq', stagedHunksQuickfixList, desc = '[Git] Create a quick fix list with staged hunks' },
  },
  config = function()
    -- alias Gclog to Gclog -100 using cnoreabbrev
    vim.cmd('cnoreabbrev Gclog Gclog -100')
  end,
}
