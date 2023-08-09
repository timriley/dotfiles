---@meta "hs.caffeinate.watcher"

---@class Watcher
local Watcher = {}

---@param callback function()
---@return Watcher
function Watcher.new(callback) end

function Watcher:start() end
function Watcher:stop() end

---@class hs.caffeinate.watcher
local module = {
    new=Watcher.new,
    didWake=0,
    willSleep=1,
    willPowerOff=2,
    screensDidSleep=3,
    screensDidWake=4,
    sessionDidResignActive=5,
    sessionDidBecomeActive=6,
    screensaverDidStart=7,
    screensaverWillStop=8,
    screensaverDidStop=9,
    screensDidLock=10,
    screensDidUnlock=11,
}

return module
