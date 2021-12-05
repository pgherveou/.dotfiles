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
  ]])
end
