local jvim = function(fn)
  return function()
    pcall(require('jvim')[fn])
  end
end

return {
  'theprimeagen/jvim.nvim',
  ft = { 'json' },
  keys = {
    { '<left>', jvim('to_parent'), desc = 'navigate to parent' },
    { '<right>', jvim('descend'), desc = 'navigate to child' },
    { '<up>', jvim('prev_sibling'), desc = 'navigate to previous sibling' },
    { '<down>', jvim('next_sibling'), desc = 'navigate to next sibling' },
  },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
}
