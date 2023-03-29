hs.loadSpoon("ControlEscape"):start()
-- replace section character with backtick on non us keyboards
local tildeHotkey = hs.hotkey.new("shift", "§", function()
    hs.eventtap.keyStroke("shift", "`")
end)
tildeHotkey:enable()

local pushToTalk = hs.loadSpoon("PushToTalk")
-- pushToTalk.app_switcher = { ["zoom.us"] = "push-to-talk", ["com.microsoft.teams"] = "push-to-talk" }
pushToTalk:start()
