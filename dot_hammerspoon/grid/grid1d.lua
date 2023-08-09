local Cell1D = require("grid.cell1d")
local class = require("utils.class")
local u = require("utils.utils")

--[[ LOGIC ]]

---@class Grid1D: Class
---@operator call: Grid1D
---@field x1 number
---@field x2 number
---@field cell_size number
local Grid1D = class("Grid1D")

---@param x1 number
---@param x2 number
---@param cell_size number
function Grid1D:__init(x1, x2, cell_size)
	self.x1 = x1
	self.x2 = x2
	self.cell_size = cell_size
end

---@param x number
---@return integer
function Grid1D:cell_idx_of(x)
	assert(x >= self.x1)
	assert(x <= self.x2)
	return math.floor((x - self.x1) / self.cell_size)
end

---@param cell_idx integer
---@return Cell1D
function Grid1D:cell(cell_idx)
	local cell_x1 = self.x1 + cell_idx * self.cell_size
	return Cell1D(cell_x1, self.cell_size)
end

---@param x number
---@return Cell1D
function Grid1D:cell_of(x)
	return self:cell(self:cell_idx_of(x))
end

---@param x number
---@param w number
---@param delta_cells integer
---@return number
function Grid1D:move_and_snap(x, w, delta_cells)
	if delta_cells == nil or delta_cells == 0 then
		return x
	end
	local cell = self:cell_of(x)
	local move_dir = u.sign(delta_cells)
	delta_cells = math.abs(delta_cells)

	if cell:endpoint_is_close_to(move_dir, x) then
		cell = cell:skip(move_dir)
	end
	local new_cell = cell:skip(move_dir * (delta_cells - 1))
	local new_x = new_cell:endpoint(move_dir)
	return u.clip(new_x, self.x1, self.x2 - w)
end

---@param x number
---@param delta_cells integer
---@return number
function Grid1D:resize_and_snap(x, delta_cells)
	return self:move_and_snap(x, 0, delta_cells)
end

--[[ MODULE ]]

return Grid1D
