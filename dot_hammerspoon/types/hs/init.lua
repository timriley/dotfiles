---@meta "hs"

---@module "hs.appfinder"
local appfinder
---@module "hs.application"
local application
---@module "hs.caffeinate"
local caffeinate
---@module "hs.canvas"
local canvas
---@module "hs.console"
local console
---@module "hs.eventtap"
local eventtap
---@module "hs.fnutils"
local fnutils
---@module "hs.hotkey"
local hotkey
---@module "hs.geometry"
local geometry
---@module "hs.keycodes"
local keycodes
---@module "hs.osascript"
local osascript
---@module "hs.mouse"
local mouse
---@module "hs.pathwatcher"
local pathwatcher
---@module "hs.screen"
local screen
---@module "hs.settings"
local settings
---@module "hs.timer"
local timer
---@module "hs.window"
local window

---@class hs
---@field configdir string
local hs = {
    appfinder=appfinder,
    application=application,
    caffeinate=caffeinate,
    canvas=canvas,
    console=console,
    fnutils=fnutils,
    eventtap=eventtap,
    geometry=geometry,
    keycodes=keycodes,
    hotkey=hotkey,
    mouse=mouse,
    osascript=osascript,
    pathwatcher=pathwatcher,
    screen=screen,
    settings=settings,
    timer=timer,
    window=window,
}

---@param name string
---@return table
function hs.getObjectMetatable(name) end

function hs.reload() end

_G["hs"] = hs
return hs
