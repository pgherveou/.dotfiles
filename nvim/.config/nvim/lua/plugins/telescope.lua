local builtin = function(fn, args)
  return function()
    pcall(require('telescope.builtin')[fn], args)
  end
end

local extension = function(name, fn, args)
  return function()
    pcall(require('telescope').extensions[name][fn], args)
  end
end

local config = function()
  local telescope = require('telescope')
  local themes = require('telescope.themes')
  local actions = require('telescope.actions')
  local fb_actions = require('telescope').extensions.file_browser.actions

  telescope.setup({
    ['ui-select'] = {
      themes.get_dropdown(),
    },
    defaults = {
      path_display = { 'truncate' },
      file_ignore_patterns = { '.git/' },
      -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua#L9
      -- https://github.com/nvim-telescope/telescope.nvim#default-mappings

      layout_config = {
        horizontal = { width = 0.95 },
      },

      mappings = {
        i = {
          ['<C-n>'] = actions.cycle_history_next,
          ['<C-p>'] = actions.cycle_history_prev,
          ['<C-c>'] = actions.close,
          ['<c-x>'] = actions.delete_buffer,
        },
        n = {
          ['q'] = actions.close,
          ['x'] = actions.delete_buffer,
          ['d'] = fb_actions.remove,
        },
      },
    },
    pickers = {
      buffers = {
        path_display = { truncate = 3 },
      },
      find_files = {
        path_display = { truncate = 3 },
      },
      file_browser = {
        path_display = { truncate = 3 },
      },
    },
  })

  telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
  telescope.load_extension('gh')
  telescope.load_extension('harpoon')
  telescope.load_extension('ui-select')
  telescope.load_extension('advanced_git_search')

  require('refactoring').setup({})
  telescope.load_extension('refactoring')
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-file-browser.nvim',
    'nvim-telescope/telescope-github.nvim',
    'aaronhallaert/advanced-git-search.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
    'ThePrimeagen/refactoring.nvim',
    'ThePrimeagen/harpoon',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = config,
  layzy = true,
  cmd = 'Telescope',
  keys = {
    -- normal
    { '<Leader>fb', builtin('buffers'), desc = 'Search buffers' },
    {
      '<Leader>fe',
      extension('file_browser', 'file_browser', { path = '%:p:h', hidden = true }),
      desc = 'Browse files',
    },
    { '<Leader>ff', builtin('find_files', { follow = true, hidden = true }), desc = 'Search files' },
    { '<Leader>fg', builtin('live_grep'), desc = 'Search with Live grep' },
    { '<Leader>fs', builtin('grep_string'), desc = 'Search from word under cursor' },
    { '<Leader>fo', builtin('oldfiles'), desc = 'Search recent files' },
    { '<Leader>fl', builtin('lsp_document_symbols'), desc = 'List lsp symbols for current buffer' },
    { '<Leader>s', builtin('lsp_document_symbols'), desc = 'List lsp symbols for current buffer' },
    { '<Leader>fr', builtin('resume'), desc = 'Resume search' },
    { '<leader>f/', extension('live_grep_args', 'live_grep_args'), desc = 'Search with raw grep' },
    -- visual
    {
      '<leader>fs',
      builtin('grep_string', { search = vim.fn.expand('<cword>') }),
      mode = 'v',
      desc = 'Search from selection',
    },
    { '<leader>rr', extension('refactoring', 'refactors'), mode = 'v', desc = 'Search refactors' },
  },
}
