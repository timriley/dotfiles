local Vector2 = require("geom.vector2")
local class = require("utils.class")

--[[ LOGIC ]]

---@class Point: Vector2
---@operator call: Point
---@field x number
---@field y number
local Point = class("Point", {
    base_cls=Vector2,
    __vector_slots={"x", "y"},
})

function Point:__tostring()
    return "(" .. self.x .. "," .. self.y .. ")"
end

--[[ MODULE ]]

return Point
