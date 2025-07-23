hs.console.clearConsole()

local control_escape = require("control_escape")
control_escape:init()
control_escape:start()

local window_keyboard = require("window_keyboard")
window_keyboard:init({
  move_mods = { "ctrl", "cmd" },
  resize_mods = { "ctrl", "alt" }
})
window_keyboard:start()

local window_mouse = require("window_mouse")
window_mouse:init({
  move_mods = { "ctrl", "cmd" },
  resize_mods = { "ctrl", "alt" },
  resize_only_bottom_right = true
})
window_mouse:start()

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
