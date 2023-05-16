dm = require "darkmode"
dm.addHandler(darkModeMenuClicked)
print('darkmode:',dm.getDarkMode())
-- dm.setDarkMode(not dm.getDarkMode())
-- print('darkmode:',dm.getDarkMode())
-- dm.setDarkMode(not dm.getDarkMode())


darkModeMenu = hs.menubar.new()
function setDarkModeMenu(enabled)

  if enabled then
    local task = hs.task.new("~/.nix-profile/bin/fish", nil, {"-c", "setDarkMode true"})
    task:start()
    darkModeMenu:setTitle("🌑")
    hs.alert.show("🌑")
  else
    local task = hs.task.new("~/.nix-profile/bin/fish", nil, {"-c", "setDarkMode false"})
    task:start()
    darkModeMenu:setTitle("🌝")
    hs.alert.show("🌝")
  end
end

function darkModeMenuClicked()
  hs.osascript.applescript('tell app "System Events" to tell appearance preferences to set dark mode to not dark mode')
  local success, darkmode = hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  setDarkModeMenu(darkmode)
end

if darkModeMenu then
  darkModeMenu:setClickCallback(darkModeMenuClicked)
  local success, darkmode = hs.osascript.applescript('tell app "System Events" to tell appearance preferences to return dark mode')
  setDarkModeMenu(darkmode)
end

