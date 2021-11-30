return function()
  vim.g.airline_theme = 'simple'
  vim.g.lightline = { colorscheme = 'tokyonight' }

  vim.g.tokyonight_style = 'storm'
  vim.g.tokyonight_italic_functions = 1

  vim.g.better_whitespace_enabled = 1
  vim.g.strip_whitespace_on_save = 1
  vim.g.strip_whitespace_confirm = 0

  vim.cmd('colorscheme tokyonight')
end
