local keys = require "keys"

-- underTap = keys.simultaneousKeyPress({}, {"h", "g"}, "_", {delay=0.05})
-- hypenTap = keys.simultaneousKeyPress({}, {"f", "j"}, "-")

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "l", nil, function() hs.console.clearConsole() end)
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "r", nil, function() hs.reload() end)
