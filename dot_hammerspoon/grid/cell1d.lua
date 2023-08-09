local Segment = require("geom.segment")
local class = require("utils.class")

--[[ LOGIC ]]

---@class Cell1D: Segment
---@operator call: Cell1D
local Cell1D = class("Cell1D", {
	base_cls=Segment,
})

---@param which_endpoint WhichEndpoint
---@param x number
---@return boolean
function Cell1D:endpoint_is_close_to(which_endpoint, x)
	return math.abs(self:endpoint(which_endpoint) - x) <= 1
end

---@param delta_cells number
---@return Cell1D
function Cell1D:skip(delta_cells)
	return Cell1D(
		self.x + delta_cells * self.w,
		self.w
	)
end

--[[ MODULE ]]

return Cell1D
