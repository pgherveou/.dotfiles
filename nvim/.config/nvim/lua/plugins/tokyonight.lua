local function get_progress()
  return '%6o %3l:%-2v'
end

-- https://github.com/ThePrimeagen/harpoon/pull/308/files

local function harpoonFiles()
  if vim.api.nvim_buf_get_option(0, 'buftype') ~= '' then
    return ''
  end
  local tabela = require('harpoon').get_mark_config()['marks']
  local currentFile = vim.fn.split(vim.api.nvim_buf_get_name(0), '/')
  currentFile = currentFile[#currentFile]
  local ret = {}
  for key, value in pairs(tabela) do
    local file = vim.fn.split(value['filename'], '/')
    file = file[#file]
    file = file == currentFile and file .. '*' or file .. ' '
    table.insert(ret, '  ' .. key .. ' ' .. file)
  end
  return table.concat(ret)
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
      transparent = true,
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

    local file_name = function()
      if vim.bo.buftype == 'terminal' then
        local name = vim.api.nvim_buf_get_name(0)
        local pattern = '^[^%s]+:'
        return name:gsub(pattern, '')
      else
        return '%f'
      end
    end
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
        lualine_c = { file_name, harpoonFiles },
      },
      inactive_winbar = {
        lualine_c = { file_name },
      },
    })
  end,
}
