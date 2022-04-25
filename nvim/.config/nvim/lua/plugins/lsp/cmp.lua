return function()
  local cmp = require('cmp')
  local compare = require('cmp.config.compare')
  local types = require('cmp.types')

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

  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    experimental = {
      ghost_text = true,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
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
