---@meta "hs.geometry"

---@class Geometry
---@field x number
---@field y number
---@field w number
---@field h number
---@field x1 number
---@field y1 number
---@field x2 number
---@field y2 number
---@field x1y1 Geometry | Point
---@field x2y2 Geometry | Point
---@field topleft Geometry | Point
---@field bottomright Geometry | Point
---@field center Geometry | Point
---@field size Geometry | Size
local Geometry = {}

---@return Geometry
function Geometry.new() end

---@return Geometry
function Geometry:copy() end

---@param other Geometry
---@return boolean
function Geometry:inside(other) end

---@class hs.geometry
---@operator call:Geometry
local module = {}

---@param w number
---@param h number
---@return Geometry
function module.size(w, h) end

return module
