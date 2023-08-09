local Point = require("geom.point")
local Size = require("geom.size")
local Rect = require("geom.rect")
local class = require("utils.class")
local anim = require("utils.animate")
local hsu = require("hammerspoon_utils")

local TitleBar = require("titlebar.title_bar")
-- local TitleBarCloseButton = require("titlebar.title_bar_close_button")
-- local TitleBarMinimizeButton = require("titlebar.title_bar_minimize_button")
local TitleBarZoomButton = require("titlebar.title_bar_zoom_button")

--[[ CONFIG ]]

local INITIAL_SCALE_FACTOR = 0.3
local PREVIEW_ALPHA = 0.6

--[[ LOGIC ]]

local hs_window_metatable = hs.getObjectMetatable("hs.window")

---@class MiniPreview: Class
---@operator call: MiniPreview
---@field mp_id integer
---@field orig_win Window
---@field orig_win_id integer
---@field ax_subrole string
---@field canvas Canvas?
---@field title_bar TitleBar
---@field timer Timer
---@field kbd_tap EventTap
local MiniPreview = class("MiniPreview")
MiniPreview.__next_mp_id = 0
---@type table<integer, MiniPreview>
MiniPreview.__mp_id_to_mini_preview = {}
---@type table<integer, MiniPreview>
MiniPreview.__orig_win_id_to_mini_preview = {}

---@param orig_win_id integer | Window
function MiniPreview.for_window(orig_win_id)
	if getmetatable(orig_win_id) == hs_window_metatable then
		---@cast orig_win_id Window
		orig_win_id = orig_win_id:id()
	end
	---@cast orig_win_id integer
	return MiniPreview.__orig_win_id_to_mini_preview[orig_win_id]
end

---@param w Window
---@return boolean
function MiniPreview.is_mini_preview_window(w)
	return w:subrole():match("^mini_preview[.]")
end

---@param mp_win Window
function MiniPreview.by_mini_preview_window(mp_win)
	local mp_id_str = mp_win:subrole():match("^mini_preview[.](%d+)$")
	if not mp_id_str then
		return nil
	end
	return MiniPreview.__mp_id_to_mini_preview[mp_id_str + 0]
end

---@param anim_data AnimData
---@param anim_done_func fun()
function MiniPreview:animate_canvas(anim_data, anim_done_func)
	local canvas = assert(self.canvas)
	---@param step_data AnimStepData
	local function anim_step_func(step_data)
		if step_data.alpha then canvas:alpha(step_data.alpha) end
		if step_data.size  then canvas:size(step_data.size)   end
		if step_data.pos   then canvas:topLeft(step_data.pos) end
	end
	anim.animate(anim_data, 0.25, anim_step_func, anim_done_func)
end

---@param orig_win Window
function MiniPreview:__init(orig_win)
	local orig_win_size = Size(orig_win:size())

	local mini_preview_id = MiniPreview.__next_mp_id
	MiniPreview.__next_mp_id = MiniPreview.__next_mp_id + 1

	self._deleted = false
	self.mp_id = mini_preview_id
	self.orig_win_id = orig_win:id()
	self.orig_win = orig_win
	self.ax_subrole = "mini_preview." .. self.mp_id

	local button_callback = function (...) self:delete() end
	local title_bar_buttons = {
		-- TitleBarCloseButton(button_callback),
		-- TitleBarMinimizeButton(button_callback),
		TitleBarZoomButton(button_callback),
	}
	self.title_bar = TitleBar(title_bar_buttons)

	local canvas = hs.canvas.new({})
	canvas:_accessibilitySubrole(self.ax_subrole)
	canvas:level(hs.canvas.windowLevels.normal)
	canvas:topLeft(orig_win:topLeft())
	canvas:size(orig_win_size)
	canvas:appendElements({
		id="img",
		type="image",
		trackMouseEnterExit=true,
	})
	canvas:appendElements({
		id="title_bar",
		type="canvas",
		canvas=self.title_bar.canvas,
		frame={x=0, y=-self.title_bar.h, w="100%", h=self.title_bar.h},
	})
	canvas:mouseCallback(function (...) self:mouse_callback(...) end)
	self.canvas = canvas

	self.timer = hs.timer.new(0.1, function () self:refresh_img() end)
	self.kbd_tap = hs.eventtap.new(
		{
			hs.eventtap.event.types.keyDown,
			hs.eventtap.event.types.keyUp,
		},
		function (...) self:on_key(...) end
	)

	MiniPreview.__mp_id_to_mini_preview[self.mp_id] = self
	MiniPreview.__orig_win_id_to_mini_preview[self.orig_win_id] = self

	self:refresh_img()
	self.canvas:show()
	self.timer:start()

	---@type AnimData
	local anim_data = {
		alpha={1, PREVIEW_ALPHA},
		size={orig_win_size, orig_win_size * INITIAL_SCALE_FACTOR},
	}

	local function anim_done_func()
		hs.window.desktop():focus()
	end

	hs.timer.doAfter(0, function ()
		hs.timer.doAfter(0, function ()
			orig_win:setTopLeft({x=100000, y=100000})
			self.canvas:level(hs.canvas.windowLevels.floating)
			self:animate_canvas(anim_data, anim_done_func)
		end)
	end)
end

---@param show boolean?
function MiniPreview:show_title_bar(show)
	show = show == nil and true or show

	local canvas = assert(self.canvas)
	local title_bar_canvas = canvas["title_bar"]

	---@param step_data AnimStepData
	local function anim_step_func(step_data)
		title_bar_canvas.frame.y = step_data.y
	end

	local y1 = -self.title_bar.h
	local y2 = 0
	if not show then
		y1, y2 = y2, y1
	end

	---@type AnimData
	local anim_data = {y={y1, y2}}
	anim.animate(anim_data, 0.15, anim_step_func)
end

function MiniPreview:hide_title_bar()
	self:show_title_bar(false)
end

function MiniPreview:delete()
	assert(not self._deleted)
	self._deleted = true

	self.timer:stop()
	self.kbd_tap:stop()

	local screen_frame = Rect(self.orig_win:screen():frame())
	local canvas = assert(self.canvas)
	local canvas_top_left = Point(canvas:topLeft())
	local canvas_size = Size(canvas:size())
	local orig_win_size = Size(self.orig_win:size())
	local r = Rect(canvas_top_left, orig_win_size)
	r = screen_frame:fit(r)

	---@type AnimData
	local anim_data = {
		alpha={canvas:alpha(), 1},
		size={canvas_size, r.size},
	}
	if canvas_top_left ~= r.top_left then
		anim_data.pos = {canvas_top_left, r.top_left}
	end
	local function anim_done_func()
		hs.timer.doAfter(0, function ()
			hs.timer.doAfter(0, function ()
				self.orig_win:setTopLeft(canvas:topLeft())
				canvas:hide()
				self.canvas = nil
			end)
		end)
	end
	self:hide_title_bar()
	self:animate_canvas(anim_data, anim_done_func)

	MiniPreview.__mp_id_to_mini_preview[self.mp_id] = nil
	MiniPreview.__orig_win_id_to_mini_preview[self.orig_win_id] = nil
end

---@return Window?
function MiniPreview:preview_window()
	local expected_subrole = self.ax_subrole
	return hs.fnutils.find(
		hsu.hammerspoon_app:visibleWindows(),
		function (w) return w:subrole() == expected_subrole end
	)
end

function MiniPreview:refresh_img()
	if self._deleted then return end
	local canvas = assert(self.canvas)
	local img = hs.window.snapshotForID(self.orig_win_id, true)
	if not img then
		return
	end
	canvas["img"].image = img
end

---@param f Geometry
function MiniPreview:setFrame(f)
	local canvas = assert(self.canvas)
	canvas:frame(f)
	self:refresh_img()
end

---@param ev Event
function MiniPreview:on_key(ev)
	local ev_type = ev:getType()
	local key_str = ev:getCharacters()

	-- "swallow" event
	ev:setType(hs.eventtap.event.types.nullEvent)

	-- handle keyDown
	if ev_type == hs.eventtap.event.types.keyDown then
		if key_str == "x" or key_str == "q" then
			self:delete()
		end
	end
end

---@param canvas Canvas
---@param ev_type string
---@param elem_id integer | string
---@param x number
---@param y number
function MiniPreview:mouse_callback(canvas, ev_type, elem_id, x, y)
	if self._deleted then return end
	local canvas = assert(self.canvas)

	local function on_enter_canvas()
		self.kbd_tap:start()
		canvas:alpha(1)
		self:show_title_bar()
	end

	local function on_exit_canvas()
		self.kbd_tap:stop()
		canvas:alpha(PREVIEW_ALPHA)
		self:hide_title_bar()
	end

	if elem_id == "img" then
		if ev_type == "mouseEnter" then
			on_enter_canvas()
		elseif ev_type == "mouseExit" then
			on_exit_canvas()
		end
	end

end

---@param w Window?
local function start_for_window(w)
	if not w then return end
	if not MiniPreview.for_window(w) then
		MiniPreview(w)
	end
end

---@param w Window?
local function stop_for_window(w)
	if not w then return end
	local mini_preview = MiniPreview.for_window(w)
	if mini_preview then
		mini_preview:delete()
	end
end

---@param w Window?
local function toggle_for_window(w)
	if not w then return end
	local mini_preview = MiniPreview.for_window(w)
	if mini_preview then
		mini_preview:delete()
	else
		start_for_window(w)
	end
end

--[[ MODULE ]]

return {
	MiniPreview=MiniPreview,
	start_for_window=start_for_window,
	stop_for_window=stop_for_window,
	toggle_for_window=toggle_for_window,
}
