return function()
  local cmp = require('cmp')
  local compare = require('cmp.config.compare')
  local types = require('cmp.types')
  local luasnip = require('luasnip')

  local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local get_bufnrs = function()
    local buf = vim.api.nvim_get_current_buf()
    local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
    if byte_size > 2 * 1024 * 1024 then -- 2 Megabyte max
      return {}
    end
    return { buf }
  end

  local buffer_src = { name = 'buffer', get_bufnrs = get_bufnrs }

  -- same as here but with Snippet last https://github.com/hrsh7th/nvim-cmp/blob/d93104244c3834fbd8f3dd01da9729920e0b5fe7/lua/cmp/config/compare.lua#L50
  local compare_kind = function(entry1, entry2)
    local kind1 = entry1:get_kind()
    kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
    local kind2 = entry2:get_kind()
    kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
    if kind1 ~= kind2 then
      if kind1 == types.lsp.CompletionItemKind.Snippet then
        return false
      end
      if kind2 == types.lsp.CompletionItemKind.Snippet then
        return true
      end
      local diff = kind1 - kind2
      if diff < 0 then
        return true
      elseif diff > 0 then
        return false
      end
    end
  end

  -- hide copilot suggestions  when cmp menu is opened

  cmp.event:on('menu_opened', function()
    vim.b.copilot_suggestion_hidden = true
  end)

  cmp.event:on('menu_closed', function()
    vim.b.copilot_suggestion_hidden = false
  end)

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<CR>'] = cmp.mapping.confirm({
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if require('copilot.suggestion').is_visible() then
          require('copilot.suggestion').accept()
          cmp.select_next_item()
        elseif cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
    }),
    experimental = {
      ghost_text = true,
    },
    sources = cmp.config.sources({
      { name = 'copilot' },
      {
        name = 'nvim_lsp',
        entry_filter = function(entry)
          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Text'
        end,
      },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      buffer_src,
    }),
    sorting = {
      priority_weight = 2,
      comparators = {
        compare.offset,
        compare.exact,
        compare.score,
        compare.recently_used,
        compare_kind,
        compare.sort_text,
        compare.length,
        compare.order,
      },
    },
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      buffer_src,
    },
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      { name = 'cmdline' },
    }),
  })
end
