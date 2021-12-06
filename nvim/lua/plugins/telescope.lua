return function()
  local telescope = require('telescope')
  local actions = require('telescope.actions')
  telescope.setup({
    defaults = {
      mappings = {
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
  :nnoremap <Leader>fr :lua require('telescope.builtin').lsp_references{}<CR>
  :nnoremap <Leader>fo :lua require('telescope.builtin').oldfiles{}<CR>
  :nnoremap <Leader>fh :lua require('telescope.builtin').command_history{}<CR>
  :nnoremap <Leader>fc :lua require('telescope.builtin').commands{}<CR>
  :nnoremap <Leader>fs :lua require('telescope.builtin').search_history{}<CR>
  :nnoremap <Leader>fe :lua require('telescope.builtin').file_browser{}<CR>
  ]])
end
