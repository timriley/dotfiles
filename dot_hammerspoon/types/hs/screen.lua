---@meta "hs.screen"

---@class Screen
local Screen = {}

---@return Geometry
function Screen:frame() end

---@module "hs.screen.watcher"
local watcher

---@class hs.screen
local module = {
    watcher=watcher,
}

---@return Screen
function module.primaryScreen() end
function module.mainScreen() end

return module
