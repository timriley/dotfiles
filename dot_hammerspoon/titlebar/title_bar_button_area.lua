local Point = require("geom.point")
local Size = require("geom.size")
local Rect = require("geom.rect")
local class = require("utils.class")

--[[ CONFIG ]]

local BUTTON_AREA_PADDING = Size(4, 2)
local BUTTON_AREA_INTER_BUTTON_PADDING = 4

--[[ LOGIC ]]

---@class TitleBarButtonArea
---@operator call: TitleBarButtonArea
---@field buttons TitleBarButton[]
---@field canvas Canvas
---@field size Size
local TitleBarButtonArea = class("TitleBarButtonArea")

---@param buttons TitleBarButton[]
function TitleBarButtonArea:__init(buttons)
	self.buttons = buttons

	local button_area_width = 0
	button_area_width = button_area_width + BUTTON_AREA_PADDING.w
	for _, button in pairs(self.buttons) do
		button_area_width = button_area_width + button.size.w
		button_area_width = button_area_width + BUTTON_AREA_INTER_BUTTON_PADDING
	end
	button_area_width = button_area_width - BUTTON_AREA_INTER_BUTTON_PADDING
	button_area_width = button_area_width + BUTTON_AREA_PADDING.w

	local button_area_height = 0
	for _, button in pairs(self.buttons) do
		button_area_height = math.max(button_area_height, button.size.w)
	end
	button_area_height = button_area_height + 2 * BUTTON_AREA_PADDING.h

	self.size = Size(button_area_width, button_area_height)

	self.canvas = hs.canvas.new({})
	self.canvas:appendElements({
		id="bg",
		type="rectangle",
		action="fill",
		fillColor={alpha=0},
		trackMouseEnterExit=true,
	})
	self.canvas:mouseCallback(function (...) self:mouse_callback(...) end)

	local curr_button_pos = Point(BUTTON_AREA_PADDING)
	local x_axis = Point:x_axis()

	---@param delta number
	local function advance_curr_button_x(delta)
		curr_button_pos = curr_button_pos + delta * x_axis
	end

	advance_curr_button_x(BUTTON_AREA_PADDING.w)
	for _, button in ipairs(self.buttons) do
		self.canvas:appendElements({
			id=button.name .. "_button",
			type="canvas",
			canvas=button.canvas,
			frame=Rect(curr_button_pos, button.size),
		})
		advance_curr_button_x(button.size.w)
		advance_curr_button_x(BUTTON_AREA_INTER_BUTTON_PADDING)
	end
	advance_curr_button_x(-BUTTON_AREA_INTER_BUTTON_PADDING)
	advance_curr_button_x(BUTTON_AREA_PADDING.w)
end

---@param canvas Canvas
---@param ev_type string
---@param elem_id integer | string
---@param x number
---@param y number
function TitleBarButtonArea:mouse_callback(canvas, ev_type, elem_id, x, y)
	if elem_id == "bg" then
		if ev_type == "mouseEnter" then
			for _, button in ipairs(self.buttons) do
				button:on_enter_button_area()
			end
		elseif ev_type == "mouseExit" then
			for _, button in ipairs(self.buttons) do
				button:on_exit_button_area()
			end
		end
	end
end

--[[ MODULE ]]

return TitleBarButtonArea
