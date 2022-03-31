local M = {}
M.file_browser = function()
  local cwd = require('telescope.utils').buffer_dir()

  -- https://github.com/nvim-telescope/telescope-file-browser.nvim#mappings
  require('telescope').extensions.file_browser.file_browser({
    cwd = cwd,
    follow = true,
    hidden = true,
    no_ignore = true,
  })
end

M.find_files = function()
  require('telescope.builtin').find_files({
    follow = true,
    hidden = true,
  })
end

M.setup = function()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  telescope.setup({
    defaults = {
      path_display = { truncate = 3 },
      file_ignore_patterns = { '.git/' },
      -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L9
      -- https://github.com/nvim-telescope/telescope.nvim#default-mappings
      mappings = {
        i = {
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<C-c>'] = actions.close,
          ['<c-d>'] = actions.delete_buffer,
        },
        n = {
          ['q'] = actions.close,
          ['x'] = actions.delete_buffer,
        },
      },
    },
  })

  telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
  telescope.load_extension('gh')
  telescope.load_extension('harpoon')

  -- mappings
  vim.cmd([[
  :nnoremap <Leader>fb :lua require('telescope.builtin').buffers{}<CR>
  :nnoremap <Leader>fe :lua require('plugins.telescope').file_browser{}<CR>
  :nnoremap <Leader>ff :lua require('plugins.telescope').find_files{}<CR>
  :nnoremap <Leader>fg :lua require('telescope.builtin').live_grep{}<CR>
  :vnoremap <leader>fs "zy:Telescope grep_string search=<C-r>z<CR>
  :nnoremap <Leader>fs :lua require('telescope.builtin').grep_string{}<CR>
  :nnoremap <Leader>fc :lua require('telescope.builtin').command_history{}<CR>
  :nnoremap <Leader>fh :lua require('telescope.builtin').search_history{}<CR>
  :nnoremap <Leader>fo :lua require('telescope.builtin').oldfiles{}<CR>
  :nnoremap <Leader>fr :Telescope resume<CR>
  :nnoremap <leader>f/ :lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>
  ]])
end

return M
