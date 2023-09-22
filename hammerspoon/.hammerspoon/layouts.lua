local menu = hs.menubar.new()

-- launch apps defined in the hs.layout
local function launchApps(layout)
  for _, app in ipairs(layout) do
    local appName = app[1]
    hs.application.launchOrFocus(appName)
  end
end

-- apply a layout and launch the apps defined in the layout
local function applyLayout(title, tooltip, layout)
  menu:setTitle(title)
  menu:setTooltip(tooltip)
  launchApps(layout)
  hs.layout.apply(layout)
end

-- create a function that returns a tuple of the laptop screen and external monitors
local function getScreens()
  local screens = hs.screen.allScreens()
  local laptopScreen = hs.fnutils.find(screens, function(screen)
    return string.find(screen:name(), 'Built-in', 1, true)
  end)

  -- external monitor is the first screen in the list that isn't the laptop screen
  local externalMonitor = hs.fnutils.find(screens, function(screen)
    return screen ~= laptopScreen
  end)

  return laptopScreen, externalMonitor
end

local function moveAppToSpace(appName, screen, space_index)
  local app = hs.application.open(appName)
  local window = app:mainWindow()

  local spaces = hs.spaces.spacesForScreen(screen)
  if #spaces < space_index then
    hs.spaces.addSpaceToScreen(screen, true)
    spaces = hs.spaces.spacesForScreen(screen)
  end

  local space = spaces[space_index]
  hs.spaces.moveWindowToSpace(window, space)
end

-- layout for laptop only
local function setLaptopOnly()
  local laptopScreen, _ = getScreens()
  applyLayout('💻', 'Laptop Layout', {
    { 'Alacritty', nil, laptopScreen, hs.layout.left50, nil, nil },
    { 'Google Chrome', nil, laptopScreen, hs.layout.right50, nil, nil },
  })
  moveAppToSpace('Element', laptopScreen, 2)
end

-- layout for laptop and monitor
local function setLaptopAndMonitor()
  local laptopScreen, externalMonitor = getScreens()
  applyLayout('🖥 + 💻', 'Laptop + Monitor Layout', {
    { 'Google Chrome', nil, laptopScreen, hs.layout.maximized, nil, nil },
    { 'Alacritty', nil, externalMonitor, hs.layout.maximized, nil, nil },
  })
  -- moveAppToSpace('Element', externalMonitor, 2)
end

-- swap all apps launched on the laptop screen to the external monitor and vice versa
local function swapLaptopAndMonitor()
  local laptopScreen, externalMonitor = getScreens()
  local allApps = hs.application.runningApplications()

  for _, app in ipairs(allApps) do
    local window = app:mainWindow()
    if window ~= nil then
      local windowScreen = window:screen()
      if windowScreen == laptopScreen then
        window:moveToScreen(externalMonitor)
      elseif windowScreen == externalMonitor then
        window:moveToScreen(laptopScreen)
      end
    end
  end
end

local function enableMenu()
  menu:setTitle('🖥')
  menu:setTooltip('No Layout')
  menu:setMenu({
    { title = 'Launch Apps', fn = launchApps },
    { title = 'Set Monitor + Laptop Layout', fn = setLaptopAndMonitor },
    { title = 'Set Laptop only Layout', fn = setLaptopOnly },
    { title = 'Swap Monitor apps', fn = swapLaptopAndMonitor },
  })
end

enableMenu()
