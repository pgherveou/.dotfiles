local function change_case(case)
  return function()
    require('textcase').current_word(case)
  end
end

local mode = { 'n', 'x' }
return {
  'johmsalas/text-case.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('textcase').setup({})
    require('telescope').load_extension('textcase')
  end,
  keys = {
    { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', mode = mode, desc = '[Change case] Telescope' },
    { 'gau', change_case('to_upper_case'), mode = mode, desc = '[Change case] upper case' },
    { 'gap', change_case('to_pascal_case'), mode = mode, desc = '[Change case] pascal case' },
    { 'gac', change_case('to_camel_case'), mode = mode, desc = '[Change case] camel case' },
    { 'gas', change_case('to_snake_case'), mode = mode, desc = '[Change case] snake case' },
    { 'gat', change_case('to_constant_case'), mode = mode, desc = '[Change case] constant case' },
  },
  cmd = {
    'TextCaseOpenTelescope',
    'TextCaseOpenTelescopeQuickChange',
    'TextCaseOpenTelescopeLSPChange',
    'TextCaseStartReplacingCommand',
  },
  lazy = true,
}
