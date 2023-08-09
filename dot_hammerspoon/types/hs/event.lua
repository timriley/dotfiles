---@meta "hs.event"

---@class EventMods : string[]
local EventMods = {}

--- @param mod string | string[]
--- @return boolean
function EventMods:contain(mod) end

---@class Event
local Event = {}

---@return integer
function Event:getType() end

---@param ev_type integer
function Event:setType(ev_type) end

---@return EventMods
function Event:getFlags() end

---@return integer
function Event:getKeyCode() end

---@return string
function Event:getCharacters() end

---@class hs.event
local module = {}

return module
