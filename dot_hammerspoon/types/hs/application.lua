---@meta "hs.application"

---@class Application
local Application = {}

---@return string
function Application:bundleID() end

---@return integer
function Application:kind() end

---@return boolean
function Application:isRunning() end

---@return boolean
function Application:isHidden() end

---@return Window[]
function Application:visibleWindows() end

---@class hs.application
local module = {}

---@param app_name string
---@return Application?
function module.get(app_name) end

---@param app_name string
---@return Application
function module.launchOrFocus(app_name) end

---@return Application[]
function module.runningApplications() end

return module
