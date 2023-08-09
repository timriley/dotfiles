local Point = require("geom.point")
local Size = require("geom.size")
local win_grid = require("win_grid")

--[[ CONFIG ]]

hs.window.animationDuration = 0

local WIN_GRID = Size(16, 8)

--[[ LOGIC ]]

---@param fn fun(w: Window, ...): nil
---@return fun(...): nil
local function focused_win_op(fn)
	return function (...)
		return fn(hs.window.focusedWindow(), ...)
	end
end

---@param fn fun(w: Window, ...): nil
---@return fun(grid_size: Size): fun(g: Point?): fun(): nil
local function focused_win_grid_op(fn)
	local wo = focused_win_op(fn)
	---@param grid_size Point
	return function (grid_size)
		---@param g Point?
		return function (g)
			return function ()
				return wo(grid_size, g)
			end
		end
	end
end

local grid_place_op  = focused_win_grid_op(win_grid.place_win )
local grid_move_op   = focused_win_grid_op(win_grid.move_win  )(WIN_GRID)
local grid_resize_op = focused_win_grid_op(win_grid.resize_win)(WIN_GRID)

---@param bind_func fun(mods: string[], key: string, fn_pressed: fun()?, fn_released: fun()?, fn_repeat: fun()?)
---@param kbd_place string[]?
---@param kbd_move string[]?
---@param kbd_resize string[]?
local function bind_hotkeys(bind_func, kbd_place, kbd_move, kbd_resize)

	---@param mods string[]
	---@param key string
	---@param f fun(...): nil
	local function bind_with_repeat(mods, key, f)
		bind_func(mods, key, f, nil, f)
	end

	local GRID_3x1 = Size(3, 1)
	local GRID_2x2 = Size(2, 2)
	local GRID_2x1 = Size(2, 1)
	local GRID_1x1 = Size(1, 1)

	if kbd_place then
		-- 3x1 grid
		bind_func(kbd_place, "1", grid_place_op(GRID_3x1)(Point(0, 0)))
		bind_func(kbd_place, "2", grid_place_op(GRID_3x1)(Point(1, 0)))
		bind_func(kbd_place, "3", grid_place_op(GRID_3x1)(Point(2, 0)))
		-- 2x2 grid
		bind_func(kbd_place, "o", grid_place_op(GRID_2x2)(Point(0, 0)))
		bind_func(kbd_place, "p", grid_place_op(GRID_2x2)(Point(1, 0)))
		bind_func(kbd_place, "l", grid_place_op(GRID_2x2)(Point(0, 1)))
		bind_func(kbd_place, ";", grid_place_op(GRID_2x2)(Point(1, 1)))
		-- 2x1 grid
		bind_func(kbd_place, "[", grid_place_op(GRID_2x1)(Point(0, 0)))
		bind_func(kbd_place, "]", grid_place_op(GRID_2x1)(Point(1, 0)))
		-- 1x1 grid
		bind_func(kbd_place, "/", grid_place_op(GRID_1x1)(Point(0, 0)))
	end

	if kbd_move then
		bind_with_repeat(kbd_move, "LEFT",  grid_move_op(Point( -1,  0)))
		bind_with_repeat(kbd_move, "RIGHT", grid_move_op(Point(  1,  0)))
		bind_with_repeat(kbd_move, "UP",    grid_move_op(Point(  0, -1)))
		bind_with_repeat(kbd_move, "DOWN",  grid_move_op(Point(  0,  1)))
		bind_func(kbd_move, ",", function ()
			focused_win_op(win_grid.center_win)(true, true)
		end)
	end

	if kbd_resize then
		bind_with_repeat(kbd_resize, "LEFT",  grid_resize_op(Point( -1,  0)))
		bind_with_repeat(kbd_resize, "RIGHT", grid_resize_op(Point(  1,  0)))
		bind_with_repeat(kbd_resize, "UP",    grid_resize_op(Point(  0, -1)))
		bind_with_repeat(kbd_resize, "DOWN",  grid_resize_op(Point(  0,  1)))
	end

end

--[[ MODULE ]]

return {
	bind_hotkeys=bind_hotkeys,
}
