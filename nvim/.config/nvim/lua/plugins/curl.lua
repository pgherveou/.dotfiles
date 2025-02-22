vim.filetype.add({ extension = { curl = 'curl' } })

return {
  'oysandvik94/curl.nvim',
  lazy = true,
  ft = { 'curl' },
  cmd = { 'CurlOpen' },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = true,
}
