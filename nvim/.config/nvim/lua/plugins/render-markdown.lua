return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'codecompanion' },
  opts = {
    win_options = {
      -- turn off wrap while rendered so tables stay aligned
      wrap = { default = vim.o.wrap, rendered = false },
    },
  },
}
