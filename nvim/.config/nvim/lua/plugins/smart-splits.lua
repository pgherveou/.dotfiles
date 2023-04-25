local smart_splits = function(fn)
  return function()
    require('smart-splits')[fn]()
  end
end

return {
  'mrjones2014/smart-splits.nvim',
  config = true,
  keys = {
    -- moving between splits
    { '<C-h>', smart_splits('move_cursor_left'), desc = 'Move cursor left' },
    { '<C-j>', smart_splits('move_cursor_down'), desc = 'Move cursor down' },
    { '<C-k>', smart_splits('move_cursor_up'), desc = 'Move cursor up' },
    { '<C-l>', smart_splits('move_cursor_right'), desc = 'Move cursor right' },

    -- resizing splits
    { '<C-S-h>', smart_splits('resize_left'), desc = 'Resize left' },
    { '<C-S-j>', smart_splits('resize_down'), desc = 'Resize down' },
    { '<C-S-k>', smart_splits('resize_up'), desc = 'Resize up' },
    { '<C-S-l>', smart_splits('resize_right'), desc = 'Resize right' },
  },
}

-- map escape b to resize left in normal mode
-- nnoremap <silent> <M-h> :lua require('smart-splits').resize_left()<CR>
