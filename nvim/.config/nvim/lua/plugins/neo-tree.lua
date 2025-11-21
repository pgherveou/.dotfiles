return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle reveal<cr>', desc = 'Open file explorer' },
  },
  lazy = true,
  cmd = { 'Neotree', 'NeotreeReveal' },
  config = function()
    require('neo-tree').setup({
      close_if_last_window = true,
      enable_git_status = false,
      default_component_configs = {
        file_size = {
          enabled = false,
        },
        last_modified = {
          enabled = false,
        },
      },
      filesystem = {
        filtered_items = {
          hide_by_name = {
            'node_modules',
            '.git',
          },
          hide_gitignored = false,
          hide_dotfiles = false,
        },
      },
    })
  end,
}
