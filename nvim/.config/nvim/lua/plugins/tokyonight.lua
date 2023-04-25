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

    local file_name = {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }
    require('lualine').setup({
      options = {
        theme = 'tokyonight',
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { 'neo-tree', 'Outline', 'fugitive' },
      },

      sections = {
        lualine_c = {
          file_name,
        },
        lualine_z = { get_progress },
      },
      winbar = {
        lualine_c = { file_name },
      },
      inactive_winbar = {
        lualine_c = { file_name },
      },
    })
  end,
}
