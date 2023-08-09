local mp = require("mini_preview")
local hsu = require("hammerspoon_utils")

--[[ STATE ]]

local hammerspoon_app = hsu.hammerspoon_app
local hammerspoon_app_bundle_id = hsu.hammerspoon_app_bundle_id

--[[ LOGIC ]]

---@return Window[]
local function my_visibleWindows()
	local result = {}
	for _, app in pairs(hs.application.runningApplications()) do
		if (
			app:kind() > 0
			or app:bundleID() == hammerspoon_app_bundle_id
		) and not app:isHidden() then
			for _, w in ipairs(app:visibleWindows()) do
				result[#result + 1] = w
			end
		end
	end
	return result
end

---@return Window[]
local function my_orderedWindows()
	local win_set = {}
	for _, w in ipairs(my_visibleWindows()) do
		win_set[w:id() or -1] = w
	end

	local result = {}
	for _, win_id in ipairs(hs.window._orderedwinids()) do
		result[#result + 1] = win_set[win_id]
	end
	return result
end

---@return Window?
local function mini_preview_under_pointer()
	local mouse_pos = hs.geometry(hs.mouse.absolutePosition())
	local mouse_screen = hs.mouse.getCurrentScreen()
	local result = hs.fnutils.find(hammerspoon_app:visibleWindows(), function (w)
		return (
			w:screen() == mouse_screen
			and mp.MiniPreview.by_mini_preview_window(w) ~= nil
			and mouse_pos:inside(w:frame())
		)
	end)
	return result
end

---@param include_mini_previews boolean?
---@return Window?
local function window_under_pointer(include_mini_previews)
	local mouse_pos = hs.geometry(hs.mouse.absolutePosition())
	local mouse_screen = hs.mouse.getCurrentScreen()
	if include_mini_previews then
		local result = mini_preview_under_pointer()
		if result then
			return result
		end
	end
	local result = hs.fnutils.find(my_orderedWindows(), function (w)
		return (
			w:screen() == mouse_screen
			and w:isStandard()
			and mouse_pos:inside(w:frame())
		)
	end)
	return result
end

--[[ MODULE ]]

return {
	my_visibleWindows=my_visibleWindows,
	my_orderedWindows=my_orderedWindows,
	window_under_pointer=window_under_pointer,
}
