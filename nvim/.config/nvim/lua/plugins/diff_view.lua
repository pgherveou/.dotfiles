return {
  'sindrets/diffview.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = { 'DiffviewOpen' },
  keys = {
    {
      '<leader>Dh',
      function()
        vim.cmd('DiffviewOpen origin/HEAD...HEAD --imply-local')
      end,
      desc = 'Review a PR',
    },
    {
      '<leader>Dc',
      function()
        vim.cmd('DiffviewOpen --cached')
      end,
      desc = 'Review stage changes',
    },
  },
  config = function()
    require('diffview').setup({
      use_icons = true,
      enhanced_diff_hl = true,
      view = {
        default = { layout = 'diff2_horizontal' },
      },
      keymaps = {
        view = {
          ['q'] = '<cmd>DiffviewClose<CR>',
        },
        file_panel = {
          ['q'] = '<cmd>DiffviewClose<CR>',
        },
      },
    })
  end,
}
