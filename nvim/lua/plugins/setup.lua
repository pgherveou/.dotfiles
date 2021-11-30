return function(callback)
  local plug = vim.fn['plug#']
  local imported = {}
  local function plug_wrap(name, config)
    if imported[name] == true then
      return
    end

    imported[name] = true
    plug(name, config)
  end

  local config_callbacks = {}
  local function import(...)
    local args = { ... }

    for _, params in ipairs(args) do
      if type(params) == 'string' then
        plug_wrap(params, vim.empty_dict())
      else
        plug_wrap(params[1], params[2])
      end
    end
    return {
      then_configure = function(config_callback)
        table.insert(config_callbacks, config_callback)
      end,
    }
  end

  vim.call('plug#begin', '~/.config/nvim/plugged')
  callback(import)

  vim.call('plug#end')
  for _, cb in ipairs(config_callbacks) do
    cb()
  end
end
