" Don't auto insert a comment when using O/o for a newline
autocmd VimEnter,BufRead,FileType * set formatoptions-=o

" run keymapviz for keymap.c files
autocmd BufWritePost ~/Github/dotfiles/qmk/**/keymap.c silent !keymapviz --config ~/Github/dotfiles/keymapviz/config.properties -t fancy -r <afile>
autocmd BufWritePost ~/Github/dotfiles/qmk/**/keymap.c edit
autocmd BufWritePost ~/Github/dotfiles/qmk/**/keymap.c redraw!

autocmd BufWritePre *.bzl,*.bazel,WORKSPACE,BUILD silent  lua require('plugins.formatter').bzl_formatter()
