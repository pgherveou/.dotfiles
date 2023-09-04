return {
  'Canop/nvim-bacon',
  lazy = true,
  cmd = { 'BaconLoad', 'BaconShow', 'BaconList' },
  keys = {
    { '!', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', desc = 'Load next bacon error' },
    { ',', ':BaconList<CR>', desc = 'Open the list of all bacon locations' },
    { '}', ':BaconNext<CR>', desc = 'Jump to the next location in the current list' },
  },
}
