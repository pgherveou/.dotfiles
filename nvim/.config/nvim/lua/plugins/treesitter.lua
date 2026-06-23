local MAX_LINES = 10000

local ensure_installed = {
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
  'bash',
  'json',
  'yaml',
  'vhs',
}

-- main branch no longer enables highlighting automatically; do it per buffer
local function ts_attach(buf)
  if vim.api.nvim_buf_line_count(buf) > MAX_LINES then
    return
  end
  if not pcall(vim.treesitter.start, buf) then
    return
  end
  -- vim.treesitter.start() disables legacy syntax; keep both for markdown
  -- (previously additional_vim_regex_highlighting = { 'markdown' })
  if vim.bo[buf].filetype == 'markdown' then
    vim.bo[buf].syntax = 'on'
  end
end

local config = function()
  require('nvim-treesitter').setup()

  -- Register custom local vhs parser (compile with :TSInstall vhs)
  require('nvim-treesitter.parsers').vhs = {
    install_info = {
      url = '/home/pg/github/tree-sitter-vhs',
      branch = 'main',
    },
  }
  vim.treesitter.language.register('vhs', { 'vhs' })

  -- Install any parsers we want that aren't compiled yet
  local installed = require('nvim-treesitter.config').get_installed('parsers')
  local missing = vim.tbl_filter(function(p)
    return not vim.tbl_contains(installed, p)
  end, ensure_installed)
  if #missing > 0 then
    require('nvim-treesitter').install(missing)
  end

  vim.api.nvim_create_autocmd('FileType', {
    callback = function(ev)
      ts_attach(ev.buf)
    end,
  })

  -- Attach to buffers already loaded before this config ran
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= '' then
      ts_attach(buf)
    end
  end
end

local ts = {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = config,
}

local ts_textobjects = {
  'nvim-treesitter/nvim-treesitter-textobjects',
  branch = 'main',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  event = 'VeryLazy',
  config = function()
    require('nvim-treesitter-textobjects').setup({
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
      },
      move = {
        set_jumps = true, -- whether to set jumps in the jumplist
      },
    })

    local select = require('nvim-treesitter-textobjects.select').select_textobject
    local selections = {
      ['as'] = '@block.outer',
      ['is'] = '@block.inner',
      ['af'] = '@function.outer',
      ['if'] = '@function.inner',
      ['aa'] = '@parameter.outer',
      ['ia'] = '@parameter.inner',
      ['ac'] = '@class.outer',
      ['ic'] = '@class.inner',
      ['al'] = '@loop.outer',
      ['il'] = '@loop.inner',
    }
    for lhs, obj in pairs(selections) do
      vim.keymap.set({ 'x', 'o' }, lhs, function()
        select(obj, 'textobjects')
      end, { desc = 'Select ' .. obj })
    end

    local move = require('nvim-treesitter-textobjects.move')
    vim.keymap.set({ 'n', 'x', 'o' }, '<Down>', function()
      move.goto_next_start('@function.outer', 'textobjects')
    end, { desc = 'Next function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<Right>', function()
      move.goto_next_start('@statement.outer', 'textobjects')
    end, { desc = 'Next statement start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<Up>', function()
      move.goto_previous_start('@function.outer', 'textobjects')
    end, { desc = 'Prev function start' })
    vim.keymap.set({ 'n', 'x', 'o' }, '<Left>', function()
      move.goto_previous_start('@statement.outer', 'textobjects')
    end, { desc = 'Prev statement start' })
  end,
}

local ts_autotag = {
  'windwp/nvim-ts-autotag',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  lazy = true,
  ft = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
  config = true,
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

return { ts, ts_textobjects, ts_autotag, ts_context }
