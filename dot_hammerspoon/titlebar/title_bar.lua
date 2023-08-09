local Point = require("geom.point")
local Size = require("geom.size")
local Rect = require("geom.rect")
local TitleBarButtonArea = require("titlebar.title_bar_button_area")
local class = require("utils.class")

--[[ CONFIG ]]

local TITLE_BAR_PADDING = Size(4, 2)

--[[ LOGIC ]]

---@class TitleBar: Class
---@operator call: TitleBar
---@field button_area TitleBarButtonArea
---@field canvas Canvas
---@field h integer
local TitleBar = class("TitleBar")

---@param buttons TitleBarButton[]
function TitleBar:__init(buttons)
	self.button_area = TitleBarButtonArea(buttons)
	self.h = 2 * TITLE_BAR_PADDING.h + self.button_area.size.h

	self.canvas = hs.canvas.new({})
	self.canvas:appendElements({
		id="bg",
		type="rectangle",
		action="fill",
		fillColor={red=0, green=0, blue=0},
	})
	self.canvas:appendElements({
		id="button_area",
		type="canvas",
		canvas=self.button_area.canvas,
		frame=Rect(Point(TITLE_BAR_PADDING), self.button_area.size),
	})
end

--[[ MODULE ]]

return TitleBar
