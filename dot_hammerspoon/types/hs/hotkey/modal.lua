---@meta "hs.hotkey.modal"

---@class Modal
local Modal = {}

---@return Modal
function Modal.new() end

function Modal:enter() end
function Modal:exit() end

---@param mods string[]
---@param key string
---@param fn_pressed fun()
---@param fn_release fun()?
---@param fn_repeat fun()?
function Modal:bind(mods, key, fn_pressed, fn_release, fn_repeat) end

---@class hs.hotkey.modal
local module = {
    new=Modal.new,
}

return module
