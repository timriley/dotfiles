---@meta "hs.window"

---@class Window
local Window = {}

---@return integer
function Window:id() end

---@return Screen
function Window:screen() end

---@return string
function Window:subrole() end

---@return boolean
function Window:isStandard() end

---@return Geometry
function Window:frame() end

---@param frame Geometry | Rect
function Window:setFrame(frame) end

---@return Geometry
function Window:size() end

---@return Geometry
function Window:topLeft(p) end

---@param p Geometry
function Window:setTopLeft(p) end

function Window:raise() end

function Window:focus() end

---@class hs.window
---@operator call(integer):Window
---@field animationDuration number
local module = {}

---@return integer[]
function module._orderedwinids() end

---@return Window
function module.desktop() end

---@return Window
function module.focusedWindow() end

---@param win_id integer | Window
---@param include_alpha boolean?
function module.snapshotForID(win_id, include_alpha) end

return module
