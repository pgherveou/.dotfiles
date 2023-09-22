local wm = require('window-management')
local hk = require('hs.hotkey')

local function windowBind(hyper, keyFuncTable)
  for key, fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end

-- * Set Window Position on screen
local hyper = { 'shift', 'ctrl', 'alt', 'cmd' }
windowBind(hyper, {
  m = wm.maximizeWindow,
  c = wm.centerOnScreen,
  h = wm.focusLeft,
  l = wm.focusRight,
  k = wm.focusTop,
  j = wm.focusBottom,
  n = wm.moveToNextScreen,
  g = wm.makeGridLayout,
})

-- bind cmd + escape to toggle fullscreen
hk.bind({ 'cmd' }, 'escape', function()
  local hm = hs.window.focusedWindow()
  hm:toggleFullScreen()
end)
