local function disable(_, bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 10000
end

local config = function()
  -- Register custom vhs parser
  local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
  parser_config.vhs = {
    install_info = {
      url = "/home/pg/github/tree-sitter-vhs",
      files = {"src/parser.c"},
      branch = "main",
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },
    filetype = "vhs",
  }

  local refactor = {
    enable = true,
  }
  if require('plugins.lsp.common').no_rust_lsp then
    refactor = {
      navigation = {
        enable = true,
        keymaps = {
          goto_definition = 'gd',
        },
      },
      smart_rename = {
        enable = true,
        keymaps = {
          smart_rename = 'gr',
        },
      },
    }
  end

  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'go',
      'rust',
      'diff',
      'typescript',
      'markdown',
      'markdown_inline',
      'tsx',
      'c',
      'cpp',
      'vim',
      'lua',
      'solidity',
      -- 'bash',
      'json',
      'yaml',
      'vhs',
    },
    refactor = refactor,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'markdown' },
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
          ['<Down>'] = '@function.outer',
          ['<Right>'] = '@statement.outer',
        },
        goto_previous_start = {
          ['<Up>'] = '@function.outer',
          ['<Left>'] = '@statement.outer',
        },
      },
    },
  })
end

local ts_autotag = {
  'windwp/nvim-ts-autotag',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  lazy = true,
  ft = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
  config = true,
}

local ts = {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    'nvim-treesitter/nvim-treesitter-refactor',
  },
  build = ':TSUpdate',
  config = config,
}

local ts_context = {
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesitter-context').setup({
      enable = true,

      min_window_height = 45, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      multiline_threshold = 4,
    })
  end,
}

return { ts, ts_autotag, ts_context }
