hs.loadSpoon("ControlEscape"):start()
-- replace section character with backtick on non us keyboards
tildeHotkey = hs.hotkey.new("shift", "§", function()
    hs.eventtap.keyStroke("shift", "`")
end)
tildeHotkey:enable()

graveAccentHotkey = hs.hotkey.new(nil, "§", function()
    hs.eventtap.keyStroke(nil, "`")
end)
graveAccentHotkey:enable()
