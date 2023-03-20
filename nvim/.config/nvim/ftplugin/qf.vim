nnoremap <buffer> <silent> dd
  \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r') <Bar> cc<CR><C-W>p

nnoremap <buffer> o <CR>zz<C-W>p

