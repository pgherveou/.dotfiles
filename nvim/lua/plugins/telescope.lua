return function()
  require('telescope').load_extension('fzf')
  -- mappings
  vim.cmd([[
  :nnoremap <Leader>fr :lua require('telescope.builtin').lsp_references{}<CR>
  ]])
end
