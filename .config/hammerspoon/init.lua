require "darkmenu"

hs.loadSpoon("ModalMgr")
hs.loadSpoon("CountDown")

hscountdM_keys = {"alt", "I"}
if spoon.CountDown then
    spoon.ModalMgr:new("countdownM")
    local cmodal = spoon.ModalMgr.modal_list["countdownM"]
    cmodal:bind('', 'Q', 'Deactivate countdownM', function() spoon.CountDown.cancel() end)
    cmodal:bind('', 'escape', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind('', '0', '5 Minutes Countdown', function()
        spoon.CountDown:startFor(5)
        spoon.ModalMgr:deactivate({"countdownM"})
    end)
    for i = 1, 9 do
        cmodal:bind('', tostring(i), string.format("%s Minutes Countdown", 10 * i), function()
            spoon.CountDown:startFor(10 * i)
            spoon.ModalMgr:deactivate({"countdownM"})
        end)
    end
    cmodal:bind('', 'return', '25 Minutes Countdown', function()
        spoon.CountDown:startFor(25)
        spoon.ModalMgr:deactivate({"countdownM"})
    end)
    cmodal:bind('', 'space', 'Pause/Resume CountDown', function()
        spoon.CountDown:pauseOrResume()
        spoon.ModalMgr:deactivate({"countdownM"})
    end)

    -- Register countdownM with modal supervisor
    hscountdM_keys = hscountdM_keys or {"alt", "I"}
    if string.len(hscountdM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hscountdM_keys[1], hscountdM_keys[2], "Enter countdownM Environment", function()
            -- I don't really know waht this does but it makes modals work bette
            hs.dockIcon(false)
            spoon.ModalMgr:deactivateAll()
            -- Show the keybindings cheatsheet once countdownM is activated
            spoon.ModalMgr:activate({"countdownM"}, "#FF6347", true)
        end)
    end

    -- spoon.CountDown.menuBarAlwaysShow = true
    spoon.CountDown.warningShow = true
    spoon.CountDown.menuBarIconActive = "⏲"
    spoon.CountDown.barCanvasHeight = 10

end

local grid = hs.geometry.size(6, 6)
hs.grid.setGrid(grid)
hs.grid.setMargins(hs.geometry.size(8,8))
-- hs.screen.mainScreen():setOrigin(0,40)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Return", function()
  hs.grid.toggleShow()
end)

hs.dockicon.show()

function spotlite(data) 
    hs.alert.show("Hey")
end

hs.hotkey.bind({"cmd", "alt"}, "space", function() 
 	local c = hs.chooser.new(spotlite)
  c:queryChangedCallback(function(text) 
    print(text)
  end)
  c:show()
end)

hs.hotkey.bind({"cmd", "shift"}, "1", function() 
  hs.application.launchOrFocus("Kitty")
end)

hs.hotkey.bind({"cmd", "shift"}, "2", function() 
  hs.application.launchOrFocus("Firefox")
end)

hs.hotkey.bind({"cmd", "shift"}, "3", function() 
  hs.application.launchOrFocus("Mail")
end)

hs.hotkey.bind({"cmd", "shift"}, "4", function() 
  hs.application.launchOrFocus("Calendar")
end)

hs.hotkey.bind({"cmd", "shift"}, "5", function() 
  hs.application.launchOrFocus("KiCad")
end)

hs.hotkey.bind({"cmd", "shift"}, "9", function()
  hs.spaces.gotoSpace(1)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "k", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,0,6,3))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "j", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,3,6,3))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "h", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(0,0,3,6))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "l", function()
  local win = hs.window.focusedWindow()
  hs.grid.set(win, hs.geometry.rect(3,0,3,6))
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, ";", function()
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

local draw = require "hs.drawing"
local ind = {}

function doMenuBar()

  local col = draw.color.x11

  screen = hs.screen.mainScreen()
  local screeng = screen:fullFrame()
  local width = screeng.w
  local mycol = { ['hex'] = '#f4f1ea', ['alpha']=0.5}
  overlay_color = {['red']=0.1, ['blue']=0.1, ['green']=0.1, ['alpha']=0.8}
  def = {mycol}
  for i,v in ipairs(def) do

    height = (screen:frame().y - screeng.y)
     c = draw.rectangle(hs.geometry.rect(screeng.x+(width*(i-1)), screeng.y,
                                                   width, height))
     c:setFillColor(v)
     c:setFill(true)
     c:setAlpha(1.0)
     c:setLevel(draw.windowLevels.overlay)
     c:setStroke(false)
     c:setBehavior(draw.windowBehaviors.canJoinAllSpaces)
     c:show()
     table.insert(ind, c)
  end
end

function delIndicators()
   if ind ~= nil then
      for i,v in ipairs(ind) do
         if v ~= nil then
            v:delete()
         end
      end
      ind = nil
   end
end


-- doMenuBar()

hs.loadSpoon("RoundedCorners")
spoon.RoundedCorners:start()

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.config/hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- https://github.com/ashfinal/awesome-hammerspoon/blob/master/init.lua
hshelp_keys = {{"alt", "shift"}, "/"}
hscountdM_keys = {"alt", "I"}
spoon.ModalMgr.supervisor:enter()
