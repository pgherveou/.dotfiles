local module = {}

module.moveToNextScreen = function()
  local w = hs.window.focusedWindow()
  if w:isFullScreen() then
    w:setFullScreen(false)
    hs.timer.doAfter(0.6, function()
      w = w:moveToScreen(w:screen():next())
      w:setFullScreen(true)
    end)
  else
    w:moveToScreen(w:screen():next())
  end
end

module.maximizeWindow = function()
  local sizeBefore = hs.window.focusedWindow():size()
  hs.window.focusedWindow():maximize()
  local sizeAfter = hs.window.focusedWindow():size()

  if sizeBefore.w == sizeAfter.w and sizeBefore.h == sizeAfter.h then
    module.makeGridLayout()
  end
end

module.centerOnScreen = function()
  hs.window.focusedWindow():centerOnScreen()
end

local function focus(direction)
  local w = hs.window.focusedWindow()
  local directionFunctionMap = {
    west = w.windowsToWest,
    east = w.windowsToEast,
    north = w.windowsToNorth,
    south = w.windowsToSouth,
  }
  local functionToCall = directionFunctionMap[direction]
  if functionToCall then
    local windows = functionToCall(w, nil, true, true)
    if #windows > 0 then
      windows[1]:focus()
    end
  else
    hs.alert.show('Unknown direction: ' .. direction)
  end
end

module.focusLeft = function()
  focus('west')
end

module.focusRight = function()
  focus('east')
end

module.focusTop = function()
  focus('north')
end

module.focusBottom = function()
  focus('south')
end

-- function that take all the window on the screen and arrange them in a grid
module.makeGridLayout = function(windows)
  -- get the current screen
  local screen = hs.screen.mainScreen()

  -- if no windows are passed, get all the windows on the main screen
  if not windows then
    windows = hs.fnutils.filter(hs.window.orderedWindows(), function(win)
      return win:screen() == screen
    end)
  end

  -- define the the grid size based on the number of windows
  local cols = math.floor(math.sqrt(#windows))
  local rows = math.ceil(#windows / cols)

  -- create the grid
  hs.grid.setMargins(hs.geometry.size(10, 10))
  local grid = hs.grid.setGrid(hs.geometry.size(rows, cols), screen)

  -- loop over all the windows and place them in the grid
  for index, win in ipairs(windows) do
    local cell = {
      x = (index - 1) % rows,
      y = math.floor((index - 1) / rows),
      w = 1,
      h = 1,
    }
    grid.set(win, cell, screen)
  end
end

return module
