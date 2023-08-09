---@meta "hs.hotkey"

---@class Hotkey
local Hotkey = {}

function Hotkey:delete() end

---@module "hs.hotkey.modal"
local modal

---@class hs.hotkey
local module = {
    modal=modal,
}

---@param mods string[]
---@param key string
---@param fn_pressed fun()
---@param fn_release fun()?
---@param fn_repeat fun()?
function module.bind(mods, key, fn_pressed, fn_release, fn_repeat) end

return module
