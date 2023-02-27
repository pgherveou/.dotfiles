return function()
  local function disable(_, bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 10000
  end

  require('nvim-treesitter.configs').setup({
    autotag = {
      enable = true,
    },
    ensure_installed = {
      'go',
      'rust',
      'typescript',
      'tsx',
      'c',
      'cpp',
      'vim',
      'lua',
      'bash',
      'json',
      'yaml',
      'help',
    },
    highlight = {
      enable = true,
      disable = disable,
    },
    textobjects = {
      select = {
        enable = true,
        disable = disable,
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          ['as'] = '@block.outer',
          ['is'] = '@block.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
        },
      },

      move = {
        enable = true,
        disable = disable,

        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']f'] = '@function.outer',
          [']a'] = '@parameter.outer',
        },
        goto_previous_start = {
          ['[f'] = '@function.outer',
          ['[a'] = '@parameter.outer',
        },
      },
    },
  })
end
