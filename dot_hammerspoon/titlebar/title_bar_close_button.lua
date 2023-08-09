local Point = require("geom.point")
local Size = require("geom.size")
local TitleBarButton = require("titlebar.title_bar_button")
local class = require("utils.class")

--[[ CONFIG ]]

local BUTTON_COLOR      = {red=0.93, green=0.41, blue=0.37}
local X_LINES_COLOR     = {red=0.41, green=0.07, blue=0.04}
local X_LINES_MARGIN    = Size(2, 2)
local X_LINES_THICKNESS = 2

--[[ LOGIC ]]

---@class TitleBarCloseButton: TitleBarButton
---@operator call: TitleBarCloseButton
local TitleBarCloseButton = class("TitleBarCloseButton", {
	base_cls=TitleBarButton,
})

---@param callback fun(ev_type: string)
function TitleBarCloseButton:__init(callback)
	TitleBarButton.__init(self, "close", callback, BUTTON_COLOR)

	local t = self.d45xy + X_LINES_MARGIN
	local top_left     = self.circle_xy00 + t
	local bottom_right = self.circle_xy11 - t
	local top_right    = Point(bottom_right.x, top_left.y)
	local bottom_left  = Point(top_left.x, bottom_right.y)

	local canvas = self.canvas
	canvas:appendElements({
		id="line_1",
		type="segments",
		action="stroke",
		strokeColor=X_LINES_COLOR,
		strokeWidth=X_LINES_THICKNESS,
		strokeCapStyle="round",
		coordinates={top_left, bottom_right},
	})
	canvas:appendElements({
		id="line_2",
		type="segments",
		action="stroke",
		strokeColor=X_LINES_COLOR,
		strokeWidth=X_LINES_THICKNESS,
		strokeCapStyle="round",
		coordinates={top_right, bottom_left},
	})
	self.extra_element_ids = {"line_1", "line_2"}
	self:hide_extra_elements()
end

--[[ MODULE ]]

return TitleBarCloseButton
