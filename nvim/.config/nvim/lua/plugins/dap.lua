-- good example https://github.com/AlexSWall/dot-files/blob/main/neovim/lua/plugins/configs/dap.lua#L92
local function dap_fn(fn)
  return function()
    pcall(require('dap')[fn])
  end
end

local function log_point()
  local dap = require('dap')
  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-treesitter/nvim-treesitter',
    'williamboman/mason.nvim',

    -- lua
    'jbyuki/one-small-step-for-vimkind',
  },
  lazy = true,
  -- cmd = { 'LuaDebugServer' },
  keys = {
    { '<F1>', dap_fn('step_back'), desc = '[DAP] step back' },
    { '<F2>', dap_fn('step_out'), desc = '[DAP] step out' },
    { '<F3>', dap_fn('step_into'), desc = '[DAP] step into' },
    { '<F4>', dap_fn('step_over'), desc = '[DAP] step over' },
    { '<F5>', dap_fn('continue'), desc = '[DAP] continue' },
    { '<F9>', dap_fn('run_to_cursor'), desc = '[DAP] run to cursor' },
    { '<F10>', dap_fn('run_last'), desc = '[DAP] run last' },
    { '<leader>dt', dap_fn('terminate'), desc = '[DAP] terminate' },
    { '<leader>dc', dap_fn('clear_breakpoints'), desc = '[DAP] open repl' },
    { '<leader>dr', dap_fn('repl.open'), desc = '[DAP] open repl' },
    { '<leader>db', dap_fn('toggle_breakpoint'), desc = '[DAP] toggle breakpoint' },
    { '<leader>dL', log_point, desc = '[DAP] Set Logpoint' },

    { '<Leader>dk', dap_fn('up'), '[DAP] Go up a debugging frame' },
    { '<Leader>dj', dap_fn('down'), '[DAP] Go down a debugging frame' },
    { '<Leader>dl', dap_fn('focus_frame'), '[DAP] Go to the current debugger line for the current frame' },

    {
      '<Leader>d<Space>',
      function()
        require('dapui').toggle({ reset = true })
      end,
      '[DAP] Toggle debugging REPL',
    },

    {
      '<Leader>dv',
      function()
        require('dapui').eval(nil, { enter = true })
      end,
      '[DAP] eval val under cursor',
    },

    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input('[DAP] Condition > '))
      end,
      desc = '[DAP] set breakpoint with condition',
    },
    {
      '<leader>de',
      function()
        require('dapui').eval()
      end,
      desc = '[DAP] eval',
    },
    {
      '<leader>dE',
      function()
        require('dapui').eval(vim.fn.input('[DAP] Expression > '))
      end,
      desc = '[DAP] eval expression',
    },
  },
  config = function()
    local dap, dapui = require('dap'), require('dapui')
    require('nvim-dap-virtual-text').setup()
    dapui.setup()

    -- bash_config()

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
  end,
}
