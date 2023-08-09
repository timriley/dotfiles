---@meta "hs.eventtap"

---@class EventTap
local EventTap = {}

---@param event_types integer[]
---@param callback fun(e: Event)
---@return EventTap
function EventTap.new(event_types, callback) end

function EventTap:start() end

function EventTap:stop() end

---@type table<string, integer>
local event_types = {}

---@class hs.eventtap
local module = {
    new=EventTap.new,
    event={types = event_types},
}

---@param mods string[]
---@param key_name string
function module.keyStroke(mods, key_name) end

---@return table<string, boolean?>
function module.checkKeyboardModifiers() end

return module
