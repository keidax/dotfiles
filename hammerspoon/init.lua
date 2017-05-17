local keys = require "keys"

underTap = keys.simultaneousKeyPress({}, {"h", "g"}, "_")

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "l", nil, function() hs.console.clearConsole() end)
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "r", nil, function() hs.reload() end)
