local class = require("utils.class")
local u = require("utils.utils")

--[[ CONFIG ]]

local SNAP_EDGE_THICKNESS = 2
local SNAP_EDGE_COLOR = {red=0, green=1, blue=1, alpha=0.5}

--[[ LOGIC ]]

---@class SnapEdgeRenderer: Class
---@operator call: SnapEdgeRenderer
---@field screen_frame Geometry
---@field dim_name "x" | "y"
---@field curr_value number?
---@field canvas Canvas?
local SnapEdgeRenderer = class("SnapEdgeRenderer")

---@param screen_frame Geometry
---@param dim_name "x" | "y"
function SnapEdgeRenderer:__init(screen_frame, dim_name)
	local rect = screen_frame:copy()
	local dim_size_name = dim_name == "x" and "w" or "h"
	rect[dim_size_name] = SNAP_EDGE_THICKNESS
	local canvas = hs.canvas.new(rect)
	canvas:appendElements({
		type="rectangle",
		action="fill",
		fillColor=SNAP_EDGE_COLOR,
	})

	self.screen_frame = screen_frame
	self.dim_name = dim_name
	self.curr_value = nil
	self.canvas = canvas
end

---@param new_value integer?
function SnapEdgeRenderer:update(new_value)
	if new_value == self.curr_value then
		return
	end
	local canvas = assert(self.canvas)
	if new_value == nil then
		canvas:hide()
	else
		local p = {x=0, y=0}
		p[self.dim_name] = new_value - SNAP_EDGE_THICKNESS / 2
		p.x = u.clip(p.x, 0, self.screen_frame.x2 - SNAP_EDGE_THICKNESS)
		p.y = u.clip(p.y, 0, self.screen_frame.y2 - SNAP_EDGE_THICKNESS)
		canvas:topLeft(p)
	end
	if self.curr_value == nil then
		canvas:show()
	end
	self.curr_value = new_value
end

function SnapEdgeRenderer:delete()
	local canvas = assert(self.canvas)
	canvas:hide()
	self.canvas = nil
end

---@param win Window
---@return SnapEdgeRenderer, SnapEdgeRenderer
local function snap_edge_renderers_for_window(win)
	local screen_frame = win:screen():frame()
	local snap_edge_renderer_x = SnapEdgeRenderer(screen_frame, "x")
	local snap_edge_renderer_y = SnapEdgeRenderer(screen_frame, "y")
	return snap_edge_renderer_x, snap_edge_renderer_y
end

--[[ MODULE ]]

return snap_edge_renderers_for_window
