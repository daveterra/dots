
local grid = hs.geometry.size(6, 6)
hs.grid.setGrid(grid)
hs.grid.setMargins(hs.geometry.size(5,5))
-- hs.screen.mainScreen():setOrigin(0,40)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Return", function()
  hs.grid.toggleShow()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "/", function()
  local win = hs.window.focusedWindow()
  hs.grid.maximizeWindow(win)
  --  local f = win:frame()
  --  local screen = win:screen()
  --  local max = screen:frame()
  --
  --  f.x = max.x + 20
  --  f.y = max.y + 20
  --  f.w = max.w - 40
  --  f.h = max.h - 40
  --  win:setFrame(f)
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

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
  local current = hs.preferencesDarkMode()
  local darkmode = hs.osascript.applescript('tell application "System Events"\nreturn dark mode of appearance preferences\nend tell')
  hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to not dark mode')
end)

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
    local task = hs.task.new("/opt/homebrew/bin/fish", nil, {"-c", "alacritty-theme ohdark"})
    task:start()
  else
    local task = hs.task.new("/opt/homebrew/bin/fish", nil, {"-c", "alacritty-theme ohlight"})
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

function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        if (appName == "BFinder") then
            -- Bring all Finder windows forward when one gets activated
            appObject:selectMenuItem({"Window", "Bring All to Front"})
            local wins = appObject:allWindows()
            hs.alert.show(#wins)
            local win = hs.window.focusedWindow()
            local f = win:frame()
            local screen = win:screen()
            local max = screen:frame()
            local cols = 4
            local rows = 4
            for i = 1, #wins do
              print(wins[i])  -- Indices start at 1 !! SO CRAZY!
              local x = max.x + (max.w / cols)*((i-1)%2)
              local y = max.y + (max.h / rows)*0
              local w = max.w / cols
              local h = max.h / rows
              local rect = hs.geometry.rect(x, y, w, h)
              local f = wins[i]:frame()
              wins[i]:setFrame(rect)
              local rect = hs.geometry.rect((i-1)%3, 0, 1, 3)
              hs.grid.set(wins[i], rect)
            end
        end
    end
end
appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

hs.loadSpoon("RoundedCorners")
spoon.RoundedCorners:start()

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
