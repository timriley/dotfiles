--[[ CONFIG ]]

hs.window.animationDuration = 0

local KBD_WIN_PLACE			= {"ctrl", "cmd"}
local KBD_WIN_MOVE			= {"ctrl", "cmd"}
local KBD_WIN_RESIZE		= {"ctrl", "alt"}
local KBD_DRAG_LIMIT_AXIS	= {"shift"}

--[[ MAIN ]]

hs.console.clearConsole()

--[[ RELOAD ]]

local reload = require("reload")
reload.start()

--[[ SPOONS ]]
-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

Install:andUse("URLDispatcher",
  {
    config = {
      url_patterns = {
        {"zoom.us/j/", "us.zoom.xos"}
        -- { "https?://3.basecamp.com", "org.mozilla.firefox" },
        -- { "https?://basecamp.com", "org.mozilla.firefox" },
        -- { "https?://app.everhour.com", "org.mozilla.firefox" },
      },
      default_handler = "com.apple.Safari"
    },
    start = true
  }
)

--[[ CONTROL ESCAPE ]]

local control_escape = require("control_escape")
control_escape:init()
control_escape:start()

--[[ MINI-PREVIEWS ]]

local mini_preview = require("mini_preview")
local win_utils = require("win_utils")

hs.hotkey.bind(KBD_WIN_PLACE, "m", function ()
	mini_preview.toggle_for_window(win_utils.window_under_pointer())
end)

--[[ KBD-WIN ]]

local kbd_win = require("kbd_win")
kbd_win.bind_hotkeys(
	hs.hotkey.bind,
	KBD_WIN_PLACE,
	KBD_WIN_MOVE,
	KBD_WIN_RESIZE
)

--[[ DRAG-TO-MOVE/RESIZE ]]

local drag = require("drag")
drag.set_kbd_mods(
	KBD_WIN_MOVE,
	KBD_WIN_RESIZE,
	KBD_DRAG_LIMIT_AXIS
)

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")