
local map = function(lhs, rhs, desc)
  if desc then
    desc = '[DAP] ' .. desc
  end

  vim.keymap.set('n', lhs, rhs, { silent = true, desc = desc })
end

return function()
  local dap, dapui = require('dap'), require('dapui')
  dapui.setup()
  map('<F1>', require('dap').step_back, 'step_back')
  map('<F2>', require('dap').step_into, 'step_into')
  map('<F3>', require('dap').step_over, 'step_over')
  map('<F4>', require('dap').step_out, 'step_out')
  map('<F5>', require('dap').continue, 'continue')

  -- TODO:
  -- disconnect vs. terminate

  map('<leader>dr', require('dap').repl.open)
  map('<leader>db', require('dap').toggle_breakpoint)
  map('<leader>dB', function()
    require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > '))
  end)

  map('<leader>de', require('dapui').eval)
  map('<leader>dE', function()
    require('dapui').eval(vim.fn.input('[DAP] Expression > '))
  end)

  -- open / close dap ui, automatically when debugging
  -- see https://github.com/rcarriga/nvim-dap-ui#usage
  -- todo look for more keymaps from tj config here: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/dap.lua
  dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
  end
end
