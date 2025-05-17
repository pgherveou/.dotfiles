return {
  'stevearc/aerial.nvim',
  lazy = true,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { 'gs', '<cmd>AerialToggle right<CR>', desc = 'Toggle Symbols outline' },
  },
  config = function()
    require('aerial').setup({
      post_parse_symbol = function(bufnr, item)
        -- only do this in Rust files
        if vim.bo[bufnr].filetype == 'rust' then
          -- grab the raw line where the symbol was defined
          local line = vim.api.nvim_buf_get_lines(bufnr, item.lnum - 1, item.lnum, false)[1]
          -- if that line starts with “impl …”
          if line and line:match('^%s*impl') then
            -- strip off any trailing “{…” and set it as the new name
            item.name = line:gsub('%s*{.*$', '')
          end
        end
        return true -- keep the symbol in the outline
      end,
    })
  end,
}
