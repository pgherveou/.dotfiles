local l = require('plugins.legendary')

return function()
  local dap, dapui = require('dap'), require('dapui')
  dapui.setup()
  -- stylua: ignore start
  l.keymaps({
    ['<F1>'] = { cmd = require('dap').step_back, desc = '[DAP] step back' },
    ['<F2>'] = { cmd = require('dap').step_into, desc = '[DAP] step into' },
    ['<F3>'] = { cmd = require('dap').step_over, desc = '[DAP] step over' },
    ['<F4>'] = { cmd = require('dap').step_out, desc = '[DAP] step out' },
    ['<F5>'] = { cmd = require('dap').continue, desc = '[DAP] continue' },
    ['<leader>dr'] = { cmd = require('dap').repl.open, desc = '[DAP] open repl' },
    ['<leader>db'] = { cmd = require('dap').toggle_breakpoint, desc = '[DAP] toggle breakpoint' },
    ['<leader>dB'] = { cmd = function() require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > ')) end, desc = '[DAP] set breakpoint with condition', },
    ['<leader>de'] = { cmd = require('dapui').eval, desc = '[DAP] eval' },
    ['<leader>dE'] = { cmd = function() require('dapui').eval(vim.fn.input('[DAP] Expression > ')) end, desc = '[DAP] eval expression', },
  })
  -- stylua: ignore end

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
