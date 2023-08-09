---@meta "hs.timer"

---@class Timer
local Timer = {}

---@param delay number
---@param fn fun()
---@return Timer
function Timer.new(delay, fn) end

function Timer:start() end

function Timer:stop() end

---@class hs.timer
local module = {
    new=Timer.new,
}

---@return integer
function module.absoluteTime() end

---@param delay number
---@param fn fun()
---@return Timer
function module.doAfter(delay, fn) end

---@param interval number
---@param fn fun()
---@return Timer
function module.doEvery(interval, fn) end

return module
