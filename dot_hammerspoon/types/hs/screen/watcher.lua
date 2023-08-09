---@meta "hs.screen.watcher"

---@class Watcher
local Watcher = {}

---@param callback function()
---@return Watcher
function Watcher.new(callback) end

function Watcher:start() end

---@class hs.screen.watcher
local module = {
    new=Watcher.new,
}

return module
