return function()
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
  telescope.load_extension('refactoring')

  -- stylua: ignore start
  require('utils').keymaps({
      ['n'] = {
        ['<Leader>fb'] = { function() require("telescope.builtin").buffers() end, desc = 'Search buffers' },
        ['<Leader>fe'] = { function() require('telescope').extensions.file_browser.file_browser({ path = '%:p:h', hidden = true }) end, desc = 'Browse files' },
        ['<Leader>ff'] = { function() require('telescope.builtin').find_files({ follow = true, hidden = true }) end, desc = 'Search files' },
        ['<Leader>fg'] = { function() require("telescope.builtin").live_grep() end, desc = 'Search with Live grep' },
        ['<Leader>fs'] = { function() require("telescope.builtin").grep_string() end, desc = 'Search from word under cursor' },
        ['<Leader>fo'] = { function() require("telescope.builtin").oldfiles() end, desc = 'Search recent files', },
        ['<Leader>fr'] = { function() require("telescope.builtin").resume() end, desc = 'Resume search' },
        ['<leader>f/'] = { function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = 'Search with raw grep', },
      },
      ['v'] = {
        ['<leader>fs'] = { function() require("telescope.builtin").grep_string({ search =  vim.fn.expand('<cword>') }) end, desc = 'Search from selection' },
        ['<leader>rr'] = { function() require("telescope").extensions.refactoring.refactors() end, desc = 'Search refactors' },
      }
  })
  -- stylua: ignore end
end
