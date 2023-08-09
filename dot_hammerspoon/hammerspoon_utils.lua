
--[[ STATE ]]

local hammerspoon_app = hs.application.get("org.hammerspoon.Hammerspoon")
assert(hammerspoon_app)
local hammerspoon_app_bundle_id = hammerspoon_app:bundleID()

--[[ MODULE ]]

return {
	hammerspoon_app=hammerspoon_app,
	hammerspoon_app_bundle_id=hammerspoon_app_bundle_id,
}
