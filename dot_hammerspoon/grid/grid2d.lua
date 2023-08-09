local Point = require("geom.point")
local Size = require("geom.size")
local Rect = require("geom.rect")
local Grid1D = require("grid.grid1d")
local class = require("utils.class")

--[[ LOGIC ]]

---@class Grid2D: Class
---@operator call: Grid2D
---@field x_grid Grid1D
---@field y_grid Grid1D
local Grid2D = class("Grid2D")

---@param frame Geometry
---@param cell_size Size
function Grid2D:__init(frame, cell_size)
	self.x_grid = Grid1D(frame.x1, frame.x2, cell_size.w)
	self.y_grid = Grid1D(frame.y1, frame.y2, cell_size.h)
end

---@param p Point
---@return Point
function Grid2D:cell_coords_of(p)
	return Point(
		self.x_grid:cell_idx_of(p.x),
		self.y_grid:cell_idx_of(p.y)
	)
end

---@param g Point
---@return Rect
function Grid2D:cell(g)
	local x_cell = self.x_grid:cell(g.x)
	local y_cell = self.y_grid:cell(g.y)
	return Rect(
		Point(x_cell.x, y_cell.x),
		Size(x_cell.w, y_cell.w)
	)
end

---@param p Point
---@return Rect
function Grid2D:cell_of(p)
	return self:cell(self:cell_coords_of(p))
end

---@param frame Geometry
---@param delta_g Point
---@return Point
function Grid2D:move_and_snap(frame, delta_g)
	return Point(
		self.x_grid:move_and_snap(frame.x1, frame.w, delta_g.x),
		self.y_grid:move_and_snap(frame.y1, frame.h, delta_g.y)
	)
end

---@param frame Geometry
---@param delta_g Point
---@return Point
function Grid2D:resize_and_snap(frame, delta_g)
	return self:move_and_snap(
		hs.geometry(frame.bottomright, {w=0, h=0}),
		delta_g
	)
end

--[[ MODULE ]]

return Grid2D
