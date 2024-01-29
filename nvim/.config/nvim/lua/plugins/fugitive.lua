-- create a function that toggle the fugitive  window.
-- it should open it vertically if it's not open
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

local function main_diff_split()
  local main_branch = vim.fn.system('git symbolic-ref --short refs/remotes/origin/HEAD')
  vim.cmd('Gvdiffsplit ' .. main_branch .. ':%')
end

return {
  'tpope/vim-fugitive',
  event = 'VeryLazy',
  cmd = { 'GlLog', 'Gclog', 'Gvdiffsplit' },
  keys = {
    { '<leader>gs', toggle_fugitive_window, desc = '[Git] status window' },
    { '<leader>gd', ':Gvdiff  !~1<cr>', desc = '[Git] diff file' },
    { '<leader>gm', main_diff_split, desc = '[Git] vertival diff split for the current file and the main branch' },
    { '<leader>gB', ':G blame<cr>', desc = '[Git] blame' },
    { '<leader>gj', ':diffget //3<cr>', desc = '[Git] Pick diffget 3' },
    { '<leader>gf', ':diffget //2<cr>', desc = '[Git] Pick diffget 2' },
    { '<leader>grc', ':G rebase --continue<cr>', desc = '[Git] Continue rebase' },
  },
  config = function()
    -- alias Gclog to Gclog -100 using cnoreabbrev
    vim.cmd('cnoreabbrev Gclog Gclog -100')
  end,
}
