---@meta "hs.fnutils"

---@class hs.fnutils
local module = {}

---@generic T
---@param haystack T[]
---@param callback fun(item: T): boolean
---@return T | nil
function module.find(haystack, callback) end

---@generic T
---@param items T[]
---@param callback fun(item: T)
function module.each(items, callback) end

---@param fn fun(...): any 
---@return fun(...): any
function module.partial(fn, ...) end

return module
