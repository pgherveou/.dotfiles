local function get_progress()
  return '%6o %3l:%-2v'
end

return {
  'folke/tokyonight.nvim',
  dependencies = {
    'nvim-lualine/lualine.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('tokyonight').setup({

      style = 'storm',
      -- on_highlights = function(hl)
      --   hl.DiffDelete = { bg = '#3f2d3d', fg = '#3f2d3d' }
      -- end,
    })

    vim.cmd('colorscheme tokyonight')
    -- vim.g.tokyonight_style = 'storm'
    -- vim.g.tokyonight_italic_functions = true
    -- vim.g.tokyonight_italic_comments = true

    require('nvim-web-devicons').setup({
      default = true,
    })

    require('lualine').setup({
      sections = {
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
          },
        },
        lualine_z = { get_progress },
      },
    })
  end,
}
