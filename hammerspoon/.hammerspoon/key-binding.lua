local wm = require('window-management')
local hk = require('hs.hotkey')

local function windowBind(hyper, keyFuncTable)
  for key, fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end

-- create a new window using cmd + n  on the current focused app and send it to the next screen
local function moveWindowToNextScreen()
  hs.eventtap.keyStroke({ 'cmd' }, 'n')
  local w = hs.window.focusedWindow()
  w:moveToScreen(w:screen():next())
end

-- create a new function using cmd + b on the current focused app and split the screen in two
local function splitScreen()
  local left = hs.window.focusedWindow()
  hs.eventtap.keyStroke({ 'cmd' }, 'n')
  local right = hs.window.focusedWindow()
  wm.makeGridLayout({ left, right })
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
  b = moveWindowToNextScreen,
  s = splitScreen,
})

-- bind cmd + escape to toggle fullscreen
hk.bind({ 'cmd' }, 'escape', function()
  local hm = hs.window.focusedWindow()
  hm:toggleFullScreen()
end)
