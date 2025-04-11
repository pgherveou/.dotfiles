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
      file_ignore_patterns = { '.git/', 'target' },
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
      live_grep = {
        additional_args = function()
          return { '--hidden', '--follow' }
        end,
      },
    },
  })

  telescope.load_extension('fzf')
  telescope.load_extension('file_browser')
  telescope.load_extension('gh')
  telescope.load_extension('harpoon')
  telescope.load_extension('ui-select')
  telescope.load_extension('advanced_git_search')

  telescope.load_extension('git_worktree')

  require('refactoring').setup({})
  telescope.load_extension('refactoring')
end

local last_file_type = 'rust'
local function get_filetype_prefix()
  -- https://blog.kianenigma.nl/posts/tech/for-those-who-don-t-want-rust-analyzer-one-regex-to-rul-them-all/
  local prefixes_by_filetype = {
    rust = '(macro_rules!|const|enum|struct|fn|trait|impl(<.*?>)?|type) ',
    solidity = '(function|contract) ',
    typescript = '(import|function|const|let|class|interface|type) ',
    lua = '(function|local|require) ',
    go = '(func|type|interface|const|var|struct|package|import) ',
  }

  local filetype = vim.bo.filetype
  if prefixes_by_filetype[filetype] then
    last_file_type = filetype
  else
    filetype = last_file_type
  end

  return prefixes_by_filetype[filetype] or prefixes_by_filetype['rust']
end

local regex_on_complete = {
  function(picker)
    vim.keymap.set('i', '<Tab>', function()
      vim.schedule(function()
        local prompt = picker:_get_prompt()
        local prefix = get_filetype_prefix()
        if prompt:find(prefix, 1, true) == 1 then
          picker:set_prompt(prompt:sub(#prefix + 1), true)
        else
          picker:set_prompt(prefix .. prompt, true)
        end
      end)
    end, { expr = true, buffer = picker.prompt_bufnr })
  end,
}
local toggle_fuzzy = {
  function(picker)
    vim.keymap.set('i', '<Tab>', function()
      vim.schedule(function()
        local prompt = picker:_get_prompt()
        if prompt:sub(1, 1) == '\'' then
          picker:set_prompt(prompt:sub(2), true)
        else
          picker:set_prompt('\'' .. prompt, true)
        end
      end)
    end, { expr = true, buffer = picker.prompt_bufnr })
  end,
}

local function regex_quick_search()
  local word = vim.fn.expand('<cword>')
  local prefix = get_filetype_prefix()
  local default_text = prefix .. word
  require('telescope.builtin').live_grep({
    default_text = default_text,
    on_complete = regex_on_complete,
  })
end

local function quick_search_no_prefix()
  local default_text = vim.fn.expand('<cword>')
  require('telescope.builtin').live_grep({
    default_text = default_text,
    on_complete = regex_on_complete,
  })
end

local function local_search()
  require('telescope.builtin').current_buffer_fuzzy_find({
    default_text = '\'',
    on_complete = toggle_fuzzy,
  })
end

local function live_grep()
  require('telescope.builtin').live_grep({
    on_complete = regex_on_complete,
  })
end

-- live_grep but on the files from the quick fix list
local quick_fix_search = function()
  local quick_fix_list = vim.fn.getqflist()
  local quick_fix_files = {}
  for _, item in ipairs(quick_fix_list) do
    local filename = vim.api.nvim_buf_get_name(item.bufnr)
    if not vim.tbl_contains(quick_fix_files, filename) then
      table.insert(quick_fix_files, filename)
    end
  end

  require('telescope.builtin').live_grep({
    prompt_title = 'Quick fix files',
    cwd = vim.fn.getcwd(),
    search_dirs = quick_fix_files,
  })
end

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-telescope/telescope-symbols.nvim',
    'polarmutex/git-worktree.nvim',
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
  lazy = true,
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
    { '<Leader>/', local_search, desc = 'Fuzzy file in file' },
    { '<Leader>fg', live_grep, desc = 'Search with Live grep' },
    { '<Leader>fm', builtin('marks'), desc = 'Search marks' },
    { '<Leader>fq', quick_fix_search, desc = 'Search file within the quick fix list' },
    { '<Leader>fs', quick_search_no_prefix, desc = 'Search from word under cursor' },
    { '<leader>f%', regex_quick_search, desc = 'Search from word under cursor with prefix' },
    { '<Leader>fo', builtin('oldfiles'), desc = 'Search recent files' },
    { '<Leader>fls', builtin('lsp_document_symbols'), desc = 'List lsp symbols for current buffer' },
    { '<Leader>flr', builtin('lsp_references'), desc = 'List lsp references' },
    { '<Leader>i', builtin('diagnostics'), desc = 'List lsp symbols for current buffer' },
    { '<Leader>fr', builtin('resume'), desc = 'Resume search' },
    { '<leader>f/', extension('live_grep_args', 'live_grep_args'), desc = 'Search with raw grep' },
    { '<leader>fj', builtin('symbols', { 'emoji' }), desc = 'Search and insert emojii' },
    {
      '<leader>fw',
      function()
        require('telescope').extensions.git_worktree.git_worktree()
      end,
      desc = 'Manage Git git_worktree',
    },
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
