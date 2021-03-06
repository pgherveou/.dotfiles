return function()
  -- vim.cmd([[
  -- set foldmethod=expr
  -- set foldexpr=nvim_treesitter#foldexpr()
  -- ]])

  local function disable(_, bufnr)
    return vim.api.nvim_buf_line_count(bufnr) > 10000
  end

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'go',
      'rust',
      'typescript',
      'c',
      'cpp',
      'vim',
      'lua',
      'bash',
      'json',
      'yaml',
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
