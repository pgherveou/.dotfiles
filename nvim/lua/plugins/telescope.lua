local M = {}
M.file_browser = function()
  local cwd = require('telescope.utils').buffer_dir()

  require('telescope.builtin').file_browser({
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
      file_ignore_patterns = { '.git/' },
      -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L9
      mappings = {
        i = {
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<C-c>'] = actions.close,
        },
        n = {
          ['q'] = actions.close,
        },
      },
    },
  })
  -- require('telescope.builtin').find_files({
  --   follow = true
  -- })
  telescope.load_extension('fzf')

  -- mappings
  vim.cmd([[
  :nnoremap <Leader>fb :lua require('telescope.builtin').buffers{}<CR>
  :nnoremap <Leader>fc :lua require('telescope.builtin').commands{}<CR>
  :nnoremap <Leader>fe :lua require('plugins.telescope').file_browser{}<CR>
  :nnoremap <Leader>ff :lua require('plugins.telescope').find_files{}<CR>
  :nnoremap <Leader>fg :lua require('telescope.builtin').live_grep{}<CR>
  :nnoremap <Leader>fh :lua require('telescope.builtin').command_history{}<CR>
  :nnoremap <Leader>fl :lua require('telescope.builtin').lsp_references{}<CR>
  :nnoremap <Leader>fo :lua require('telescope.builtin').oldfiles{}<CR>
  :nnoremap <Leader>fr :Telescope resume<CR>
  :nnoremap <Leader>fs :lua require('telescope.builtin').search_history{}<CR>
  :nnoremap <leader>f/ :lua require("telescope").extensions.live_grep_raw.live_grep_raw()<CR>
  ]])
end

return M
