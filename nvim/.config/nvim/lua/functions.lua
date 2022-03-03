local pairs = { ['('] = ')', ['['] = ']', ['{'] = '}' }
local closers = { [')'] = '(', [']'] = '[', ['}'] = '{' }

function SearchPair()
  vim.api.nvim_command(':call searchpair(\'[\',\'\',\']\',\'b\')')
end
