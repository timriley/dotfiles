---@meta "hs.pathwatcher"

---@class PathWatcher
local PathWatcher = {}

function PathWatcher:start() end
function PathWatcher:stop() end

---@param path string
---@param callback function()
---@return PathWatcher
function PathWatcher.new(path, callback) end

---@class hs.pathwatcher
local module = {
    new=PathWatcher.new,
}

return module
