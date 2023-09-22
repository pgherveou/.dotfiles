hs.window.animationDuration = 0
hs.loadSpoon('EmmyLua')
require('window-management')
require('key-binding')
-- require('layouts')

-- watch file change and reload hammerspoon config
local configPath = os.getenv('HOME') .. '/.hammerspoon/'
hs.pathwatcher
  .new(configPath, function()
    hs.reload()
  end)
  :start()

P = function(v)
  print(hs.inspect(v))
end

-- print 'Reloading' and the time to the console
hs.printf('Reloading at %s', os.date())
