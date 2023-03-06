local new_note = function()
  local text = vim.fn.input('title > ')
  vim.cmd('ObsidianNew ' .. text)
end

return {
  'epwalsh/obsidian.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  lazy = true,
  keys = {
    { '<leader>ns', ':ObsidianSearch<CR>', desc = 'Search obsidian' },
    { '<leader>nt', ':ObsidianToday<CR>', desc = 'Create / Edit daily note' },
    { '<leader>nn', new_note, desc = 'Create new note' },
  },
  config = function()
    require('obsidian').setup({
      dir = '~/github/notes',
      note_id_func = function(title)
        -- If title is given, transform it into valid file name.
        if title ~= nil then
          return title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        end

        -- If title is nil, just add 4 random uppercase letters to the suffix.
        local suffix = ''
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
        return tostring(os.date('%Y-%m-%d-')) .. suffix
      end,
      daily_notes = {
        folder = 'daily',
      },
      completion = {
        nvim_cmp = true,
      },
    })
  end,
}
