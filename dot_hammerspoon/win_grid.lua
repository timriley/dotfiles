local Size = require("geom.size")
local Grid2D = require("grid.grid2d")

--[[ LOGIC ]]

---@param win Window
---@param center_horiz boolean
---@param center_vert boolean
local function center_win(win, center_horiz, center_vert)
	if not win then return end
	local win_frame = win:frame()
	local screen_frame = win:screen():frame()

	win_frame.center = {
		(center_horiz and screen_frame or win_frame).center.x,
		(center_vert  and screen_frame or win_frame).center.y,
	}
	win:setFrame(win_frame)
end

---@param win Window
---@param grid_size Size
local function _grid(win, grid_size)
	local screen_frame = win:screen():frame()
	local cell_size = Size(
		math.floor(screen_frame.w / grid_size.w),
		math.floor(screen_frame.h / grid_size.h)
	)
	return Grid2D(screen_frame, cell_size)
end

---@param win Window
---@param grid_size Size
---@param g Point
local function place_win(win, grid_size, g)
	if not win then return end
	local grid = _grid(win, grid_size)
	win:setFrame(grid:cell(g))
end

---@param win Window
---@param grid_size Size
---@param dg Point
local function move_win(win, grid_size, dg)
	if not win then return end
	local grid = _grid(win, grid_size)
	local win_frame = win:frame()
	win_frame.topleft = grid:move_and_snap(win_frame, dg)
	win:setFrame(win_frame)
end

---@param win Window
---@param grid_size Size
---@param dg Point
local function resize_win(win, grid_size, dg)
	if not win then return end
	local grid = _grid(win, grid_size)
	local win_frame = win:frame()
	win_frame.bottomright = grid:resize_and_snap(win_frame, dg)
	win:setFrame(win_frame)
end

--[[ MODULE ]]

return {
	center_win=center_win,
	place_win=place_win,
	move_win=move_win,
	resize_win=resize_win,
}
