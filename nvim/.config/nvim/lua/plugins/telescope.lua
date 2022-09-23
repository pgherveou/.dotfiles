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
  local themes = require('telescope.themes')
  local actions = require('telescope.actions')
  local fb_actions = require('telescope').extensions.file_browser.actions

  telescope.setup({
    ['ui-select'] = {
      themes.get_dropdown(),
    },
    defaults = {
      -- path_display = { truncate = 3 },
      file_ignore_patterns = { '.git/' },
      -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L9
      -- https://github.com/nvim-telescope/telescope.nvim#default-mappings

      layout_config = {
        horizontal = { width = 0.95 },
      },

      mappings = {
        i = {
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<C-c>'] = actions.close,
          ['<c-x>'] = actions.delete_buffer,
        },
        n = {
          ['q'] = actions.close,
          ['x'] = actions.delete_buffer,
          ['d'] = fb_actions.remove,
        },
      },
    },
    pickers = {
      buffers = {
        path_display = { truncate = 3 },
      },
      find_files = {
        path_display = { truncate = 3 },
      },
      file_browser = {
        path_display = { truncate = 3 },
      },
    },
  })

  telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
  telescope.load_extension('gh')
  telescope.load_extension('harpoon')
  telescope.load_extension('git_worktree')
  telescope.load_extension('ui-select')
  telescope.load_extension('refactoring')

  -- mappings
  vim.cmd([[
  :nnoremap <Leader>fb :lua require('telescope.builtin').buffers{}<CR>
  :nnoremap <Leader>fe :Telescope file_browser hidden=true path=%:p:h respect_gitignore=false<CR>
  :nnoremap <Leader>ff :lua require('plugins.telescope').find_files{}<CR>
  :nnoremap <Leader>fg :lua require('telescope.builtin').live_grep{}<CR>
  :vnoremap <leader>fs "zy:Telescope grep_string search=<C-r>z<CR>
  :nnoremap <Leader>fs :lua require('telescope.builtin').grep_string{}<CR>
  :nnoremap <Leader>fc :lua require('telescope.builtin').command_history{}<CR>
  :nnoremap <Leader>fh :lua require('telescope.builtin').search_history{}<CR>
  :nnoremap <Leader>fo :lua require('telescope.builtin').oldfiles{}<CR>
  :nnoremap <Leader>fr :Telescope resume<CR>
  :nnoremap <leader>f/ :lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>
  :nnoremap <leader>wt :lua require("telescope").extensions.git_worktree.git_worktrees()<CR>
  :nnoremap <leader>cw :lua require("telescope").extensions.git_worktree.create_git_worktree()<CR>

  :vnoremap <leader>rr :lua require("telescope").extensions.refactoring.refactors()<CR>
  ]])
end

return M
