return {
  'tpope/vim-fugitive',
  config = function()
    require('utils').keymaps({
      ['n'] = {
        ['<leader>gs'] = { ':vertical G<cr>', desc = '[Git] status window' },
        ['<leader>gj'] = { ':diffget //3<cr>', desc = '[Git] Pick diffget 3' },
        ['<leader>gf'] = { ':diffget //2<cr>', desc = '[Git] Pick diffget 2' },
        ['<leader>grc'] = { ':G rebase --continue<cr>', desc = '[Git] Continue rebase' },
      },
    })
  end,
}
