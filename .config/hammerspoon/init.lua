hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  local current = hs.preferencesDarkMode()
  local darkmode = hs.osascript.applescript('tell application "System Events"\nreturn dark mode of appearance preferences\nend tell')
  hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to not dark mode')
end)

local grid = hs.geometry.size(6, 6)
hs.grid.setGrid(grid)
hs.grid.setMargins(hs.geometry.size(5,5))
-- hs.screen.mainScreen():setOrigin(0,40)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Return", function()
  hs.grid.toggleShow()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,0,6,3))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,3,6,3))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,0,3,6))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(3,0,3,6))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  local win = hs.window.focusedWindow()
  hs.grid.maximizeWindow(win)
  arrangeAllWindows()
end)

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end

darkModeMenu = hs.menubar.new()
function setDarkModeMenu(enabled)
  if enabled then
    darkModeMenu:setTitle("🌑")
  else
    darkModeMenu:setTitle("🌝")
  end
end

function darkModeMenuClicked()
  hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to not dark mode')
  local success, darkmode = hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  setDarkModeMenu(darkmode)
  hs.alert.show(darkmode)
  if darkmode then
    local task = hs.task.new("/opt/homebrew/bin/fish", nil, {"-c", "setDarkMode true"})
    task:start()
  else
    local task = hs.task.new("/opt/homebrew/bin/fish", nil, {"-c", "setDarkMode false"})
    task:start()
  end
end

if darkModeMenu then
  darkModeMenu:setClickCallback(darkModeMenuClicked)
  local success, darkmode = hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  hs.alert.show(darkmode)
  setDarkModeMenu(darkmode)
end

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("☕")
    else
        caffeine:setTitle("💤")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

function arrangeAllWindows()
  local windows = hs.window.allWindows()
  hs.alert.show(string.format("Arranging %s windows", #windows))
  for i = 1, #windows do
    hs.grid.snap(windows[i])
  end
end

function finderWatcher(element, event, watcher, data)
  hs.alert.show("Hey there")
end

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        hs.alert.show(appName)
        if (appName == "Finder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
            local wins = appObject:allWindows()
            hs.alert.show(#wins)

            local win = hs.window.focusedWindow()
            local screen = win:screen()
            local max = screen:frame()

            element = hs.uielement.focusedElement()
            local watcher = element:newWatcher(finderWatcher)
            watcher:start({hs.uielement.watcher.windowCreated, hs.uielement.watcher.focusedWindowChanged, hs.uielement.watcher.focusedElementChanged})

            for i = 1, #wins do
              id = wins[i]:id()
              if id == 0 then
                wins[i] = nil
              end
            end

            hs.window.tiling.tileWindows(wins, max)
        end
    end
end

local appsToAutoTile = {"Finder", "Firefox"}

function autoTile(this_win, app_name, event)
  -- local wins =  this_win:application():allWindows()
  local wf = hs.window.filter.new(app_name)
	:setOverrideFilter({
		rejectTitles = { "^Quick Look$", "^Move$", "^Copy$", "^Finder Settings$", " Info$", "^$" }, 	 allowRoles = "AXStandardWindow",
    hasTitlebar = true,
	})
  local wins = wf:getWindows()

  if #wins == 1 then
    hs.grid.maximizeWindow(wins[1])
  elseif #wins == 2 then
    hs.grid.set(wins[1], hs.geometry.rect(0,0,3,6))
    hs.grid.set(wins[2], hs.geometry.rect(3,0,3,6))
  elseif #wins == 3 then
    hs.grid.set(wins[1], hs.geometry.rect(0,0,2,6))
    hs.grid.set(wins[2], hs.geometry.rect(2,0,2,6))
    hs.grid.set(wins[3], hs.geometry.rect(4,0,2,6))
  elseif #wins == 4 then
    hs.grid.set(wins[1], hs.geometry.rect(0,0,3,3))
    hs.grid.set(wins[2], hs.geometry.rect(3,0,3,3))
    hs.grid.set(wins[3], hs.geometry.rect(0,3,3,3))
    hs.grid.set(wins[4], hs.geometry.rect(3,3,3,3))
  else
    local max = hs.window.focusedWindow():screen():frame()
    hs.window.tiling.tileWindows(wins, max)
  end

  if #wins > 1 then
		local app = hs.application.frontmostApplication()
		app:selectMenuItem { "Window", "Bring All to Front" }
	end
end

wf_finder = hs.window.filter.new(appsToAutoTile)
	:setOverrideFilter({
		-- exclude various special windows for Finder.app
    -- "^$" excludes the Desktop, which has no window title
		rejectTitles = { "^Quick Look$", "^Move$", "^Copy$", "^Finder Settings$", " Info$", "^$" }, 	 allowRoles = "AXStandardWindow",
    hasTitlebar = true,
	})
	:subscribe(hs.window.filter.windowCreated, autoTile)
	:subscribe(hs.window.filter.windowDestroyed, autoTile)

-- appWatcher = hs.application.watcher.new(applicationWatcher)
-- appWatcher:start()

hs.loadSpoon("RoundedCorners")
spoon.RoundedCorners:start()

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
