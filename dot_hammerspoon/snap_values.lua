local class = require("utils.class")
local wu = require("win_utils")
local mp = require("mini_preview")

--[[ CONFIG ]]

local SNAP_THRESHOLD = 25

--[[ LOGIC ]]

---@alias Bucket table<integer, boolean>

---@class SnapValues: Class
---@operator call: SnapValues
---@field min_value integer
---@field max_value integer
---@field buckets table<integer, Bucket>
local SnapValues = class("SnapValues")

---@param min_value integer
---@param max_value integer
function SnapValues:__init(min_value, max_value)
	self.min_value = min_value
	self.max_value = max_value
	self.buckets = {}
end

---@param value number
function SnapValues:add(value)
	if value < self.min_value then return end
	if value > self.max_value then return end
	local buckets = self.buckets
	local mid_bucket = math.floor(value / SNAP_THRESHOLD)
	for b = mid_bucket - 1, mid_bucket + 1 do
		if not buckets[b] then buckets[b] = {} end
		buckets[b][value] = true
	end
end

---@param q integer
---@return integer?, integer?
function SnapValues:query(q)
	local bucket = math.floor(q / SNAP_THRESHOLD)
	for value in pairs(self.buckets[bucket] or {}) do
		local delta = value - q
		if math.abs(delta) <= SNAP_THRESHOLD then
			return value, delta
		end
	end
	return nil, nil
end

---@param win Window
---@return SnapValues, SnapValues
local function snap_values_for_window(win)
	local screen = win:screen()
	local screen_frame = screen:frame()

	local snap_values_x = SnapValues(screen_frame.x1, screen_frame.x2)
	local snap_values_y = SnapValues(screen_frame.y1, screen_frame.y2)

	snap_values_x:add(screen_frame.x1)
	snap_values_x:add(screen_frame.x2)
	snap_values_x:add(screen_frame.center.x)

	snap_values_y:add(screen_frame.y1)
	snap_values_y:add(screen_frame.y2)
	snap_values_y:add(screen_frame.center.y)

	-- edges of other on-screen windows
	hs.fnutils.each(wu.my_visibleWindows(), function (w)
		if w:screen() ~= screen then return end
		if not w:isStandard() then return end
		if w == win then return end
		if mp.MiniPreview.for_window(w) then return end
		local win_frame = w:frame()
		snap_values_x:add(win_frame.x1)
		snap_values_x:add(win_frame.x2)
		snap_values_y:add(win_frame.y1)
		snap_values_y:add(win_frame.y2)
	end)

	return snap_values_x, snap_values_y
end

--[[ MODULE ]]

return snap_values_for_window
