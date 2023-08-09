local class = require("utils.class")

--[[ LOGIC ]]

---@alias WhichEndpoint -1 | 1

---@class Segment: Class
---@operator call: Segment
---@field x number
---@field w number
---@field x1 number
---@field x2 number
local Segment = class("Segment", {
	props={"x", "w", "x1", "x2"},
})

---@param x number
---@param w number
function Segment:__init(x, w)
	assert(w >= 0)
	self._x = x
	self._w = w
end

---@return number
function Segment:get_x()  return self._x end
---@return number
function Segment:get_w()  return self._w end
---@return number
function Segment:get_x1() return self._x end
---@return number
function Segment:get_x2() return self._x + self._w end

---@param which_endpoint WhichEndpoint
---@return number
function Segment:endpoint(which_endpoint)
	return (
		which_endpoint == -1 and self.x1
		or which_endpoint == 1 and self.x2
		or error("invalid value " .. which_endpoint .. " for which_endpoint")
	)
end

---@param other Segment | number
---@return boolean
function Segment:contains(other)
	if type(other) == "number" then
		return other >= self.x1 and other <= self.x2
	else
		return other.x1 >= self.x1 and other.x2 <= self.x2
	end
end

---@param other Segment
---@return boolean
function Segment:intersects(other)
	if other.x1 <= self.x1 then
		return other.x2 >= self.x1
	end
	return other.x1 <= self.x2
end

---@param other Segment
---@return boolean
function Segment:__eq(other)
	return self._x == other._x and self._w == other._w
end

---@param offset number
---@return Segment
function Segment:__add(offset)
	return Segment(self._x + offset, self._w)
end

--[[ MODULE ]]

return Segment
