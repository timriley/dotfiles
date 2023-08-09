---@meta "hs.canvas"

---@alias CanvasElement table<string, any>

---@class Canvas
local Canvas = {}

---@param obj table<string, any>
---@return Canvas
function Canvas.new(obj) end

---@return integer
function Canvas:level() end

---@param level integer
---@return nil
function Canvas:level(level) end

---@return Geometry
function Canvas:frame() end

---@param frame Geometry | Rect
---@return nil
function Canvas:frame(frame) end

---@return Geometry
function Canvas:topLeft() end

---@param p Geometry | Point
---@return nil
function Canvas:topLeft(p) end

---@return Geometry
function Canvas:size() end

---@param size Geometry | Size
---@return nil
function Canvas:size(size) end

---@return string?
function Canvas:_accessibilitySubrole() end

---@param subrole string
---@return nil
function Canvas:_accessibilitySubrole(subrole) end

---@param elements CanvasElement[]
function Canvas:appendElements(elements) end

---@param element CanvasElement
---@param index number?
function Canvas:assignElement(element, index) end

---@return number
function Canvas:alpha() end

---@param alpha number
---@return nil
function Canvas:alpha(alpha) end

---@param index integer
---@param text string
---@return Geometry
function Canvas:minimumTextSize(index, text) end

function Canvas:hide() end

function Canvas:show() end

function Canvas:delete() end

---@param callback function()
function Canvas:mouseCallback(callback) end

---@class hs.canvas
---@field windowLevels table<string, integer>
local module = {
    new=Canvas.new,
}

return module
