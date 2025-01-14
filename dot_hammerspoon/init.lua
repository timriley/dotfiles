--[[ MAIN ]]

hs.console.clearConsole()

--[[ SPOONS ]]
-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

Install:andUse("URLDispatcher",
  {
    config = {
      url_patterns = {
        { "zoom.us/j/", "us.zoom.xos" }
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

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
