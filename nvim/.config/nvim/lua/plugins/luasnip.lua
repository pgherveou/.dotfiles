return function()
  local ls = require('luasnip')
  local types = require('luasnip.util.types')

  ls.config.set_config({
    -- This tells LuaSnip to remember to keep around the last snippet.
    -- You can jump back into it even if you move outside of the selection
    history = true,

    -- This one is cool cause if you have dynamic snippets, it updates as you type!
    updateevents = 'TextChanged,TextChangedI',

    -- Autosnippets:
    enable_autosnippets = true,

    -- Crazy highlights!!
    -- #vid3
    -- ext_opts = nil,
    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { ' « ', 'NonTest' } },
        },
      },
    },
  })

  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file('lua/plugins/snips/*.lua', true)) do
    loadfile(ft_path)()
  end
end

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
-- vim.keymap.set({ 'i', 's' }, '<Tab>', function()
--   if ls.expand_or_jumpable() then
--     ls.expand_or_jump()
--   end
-- end, { silent = true })
--
-- -- this always moves to the previous item within the snippet
-- vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
--   if ls.jumpable(-1) then
--     ls.jump(-1)
--   end
-- end, { silent = true })
--
-- vim.keymap.set('i', '<C-E>', function()
--   if ls.choice_active() then
--     ls.change_choice(1)
--   end
-- end)
--
-- vim.keymap.set('i', '<c-u>', require('luasnip.extras.select_choice'))

-- shortcut to source my luasnips file again, which will reload my snippets
-- vim.keymap.set('n', '<leader><leader>s', '<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>')
