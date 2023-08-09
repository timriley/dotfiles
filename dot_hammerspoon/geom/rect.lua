local Point = require("geom.point")
local Size = require("geom.size")
local Segment = require("geom.segment")
local class = require("utils.class")

--[[ LOGIC ]]

---@class Rect: Class
---@operator call: Rect
---@field x number
---@field y number
---@field w number
---@field h number
---@field x1 number
---@field y1 number
---@field x2 number
---@field y2 number
---@field size Size
---@field top_left Point
---@field mid_left Point
---@field bottom_left Point
---@field top_center Point
---@field center Point
---@field bottom_center Point
---@field top_right Point
---@field mid_right Point
---@field bottom_right Point
---@field h_segment Segment
---@field v_segment Segment
local Rect = class("Rect", {
	props={
		"x1", "y1", "x2", "y2",
		"size",
		"top_left", "mid_left", "bottom_left",
		"top_center", "center", "bottom_center",
		"top_right", "mid_right", "bottom_right",
		"h_segment", "v_segment",
	},
})

---@param arg_1 Point | Geometry
---@param arg_2 Size?
function Rect:__init(arg_1, arg_2)
	self.x = arg_1.x
	self.y = arg_1.y
	if arg_2 == nil then
		self.w = arg_1.w
		self.h = arg_1.h
	else
		self.w = arg_2.w
		self.h = arg_2.h
	end
end

function Rect:__tostring()
	return tostring(self.top_left) .. "+" .. tostring(self.size)
end

---@return number
function Rect:get_x1() 				return self.x											end
---@return number
function Rect:get_y1() 				return self.y											end
---@return number
function Rect:get_x2() 				return self.x + self.w									end
---@return number
function Rect:get_y2() 				return self.y + self.h									end

---@return Size
function Rect:get_size() 			return Size(self.w, self.h)								end

---@return Point
function Rect:get_top_left()      	return Point(self.x,              self.y             )	end
---@return Point
function Rect:get_mid_left()      	return Point(self.x,              self.y + self.h / 2)	end
---@return Point
function Rect:get_bottom_left()   	return Point(self.x,              self.y + self.h    )	end

---@return Point
function Rect:get_top_center()    	return Point(self.x + self.w / 2, self.y             )	end
---@return Point
function Rect:get_center()       	return Point(self.x + self.w / 2, self.y + self.h / 2)	end
---@return Point
function Rect:get_bottom_center() 	return Point(self.x + self.w / 2, self.y + self.h    )	end

---@return Point
function Rect:get_top_right()     	return Point(self.x + self.w,     self.y             )	end
---@return Point
function Rect:get_mid_right()		return Point(self.x + self.w,     self.y + self.h / 2)	end
---@return Point
function Rect:get_bottom_right()	return Point(self.x + self.w,     self.y + self.h    )	end

---@return Segment
function Rect:get_h_segment()		return Segment(self.x, self.w)							end
---@return Segment
function Rect:get_v_segment()		return Segment(self.y, self.h)							end

---@param other Rect | Point
---@return boolean
function Rect:contains(other)
	if class.is_instance(other, Point) then
		return (
			self.h_segment:contains(other.x) and
			self.v_segment:contains(other.y)
		)
	else
		return (
			self.h_segment:contains(other.h_segment) and
			self.v_segment:contains(other.v_segment)
		)
	end
end

---@param other Rect
---@return boolean
function Rect:intersects(other)
	return (
		self.h_segment:intersects(other.h_segment) and
		self.v_segment:intersects(other.v_segment)
	)
end

---@param r Rect
---@return Rect
function Rect:fit(r)
	local x, y = r.x, r.y
	local x_overshoot = r.x2 - self.x2
	local y_overshoot = r.y2 - self.y2
	if x_overshoot > 0 then x = x - x_overshoot end
	if y_overshoot > 0 then y = y - y_overshoot end
	if x < self.x1 then x = self.x1 end
	if y < self.y1 then y = self.y1 end
	return Rect(Point(x, y), r.size)
end

---@param other Rect
---@return boolean
function Rect:__eq(other)
	return (
		    self.x == other.x
		and self.y == other.y
		and self.w == other.w
		and self.h == other.h
	)
end

---@param offset Point
---@return Rect
function Rect:__add(offset)
	return Rect(self.top_left + offset, self.size)
end

--[[ MODULE ]]

return Rect
