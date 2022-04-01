local M = {}
M.setup = function()
  vim.cmd([[
  :nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
  :nnoremap <silent><leader>h :lua require("harpoon.ui").toggle_quick_menu()<CR>
  :nnoremap <silent><leader>tc :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>
  :nnoremap <silent><Tab>j :lua require("harpoon.ui").nav_file(1)<CR>
  :nnoremap <silent><Tab>k :lua require("harpoon.ui").nav_file(2)<CR>
  :nnoremap <silent><Tab>k :lua require("harpoon.ui").nav_file(3)<CR>
  :nnoremap <silent><Tab>l :lua require("harpoon.ui").nav_file(4)<CR>
  ]])
end

return M
