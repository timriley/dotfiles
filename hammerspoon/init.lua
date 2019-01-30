-- https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

Install:andUse("URLDispatcher",
  {
    config = {
      url_patterns = {
        { "https?://3.basecamp.com", "com.fluidapp.FluidApp2.Basecamp" },
        { "https?://basecamp.com", "com.fluidapp.FluidApp2.Basecamp" },
      },
      default_handler = "com.apple.Safari"
    },
    start = true
  }
)

hs.loadSpoon('ControlEscape'):start() -- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon
require('windows')

hs.notify.show("Welcome to Hammerspoon", "Have fun!", "")
