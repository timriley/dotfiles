local window_grid = require("window_grid")

local window_keyboard = {}

function window_keyboard:init(config)
  self.grid = window_grid.createGrid(16, 8) -- Create a 16x8 grid

  self.config = config or {}
  self.config.move_mods = self.config.move_mods or { "ctrl", "cmd" }
  self.config.resize_mods = self.config.resize_mods or { "ctrl", "alt" }

  hs.window.animationDuration = 0
end

function window_keyboard:start()
  local move_mods = self.config.move_mods
  local resize_mods = self.config.resize_mods

  -- Point helper
  local function p(x, y)
    return window_grid.createPoint(x, y)
  end

  -- Centering and maximizing operations
  if move_mods and #move_mods > 0 then
    hs.hotkey.bind(move_mods, ",", function()
      self.grid:centerWin(hs.window.focusedWindow(), true, true)
    end)

    hs.hotkey.bind(move_mods, "/", function()
      self.grid:maximizeWin(hs.window.focusedWindow(), true, true)
    end)
  end

  -- Window movement bindings
  if move_mods and #move_mods > 0 then
    local move_left = function()
      self.grid:moveWin(hs.window.focusedWindow(), p(-1, 0))
    end

    local move_right = function()
      self.grid:moveWin(hs.window.focusedWindow(), p(1, 0))
    end

    local move_up = function()
      self.grid:moveWin(hs.window.focusedWindow(), p(0, -1))
    end

    local move_down = function()
      self.grid:moveWin(hs.window.focusedWindow(), p(0, 1))
    end

    hs.hotkey.bind(move_mods, "left", move_left, nil, move_left)
    hs.hotkey.bind(move_mods, "right", move_right, nil, move_right)
    hs.hotkey.bind(move_mods, "up", move_up, nil, move_up)
    hs.hotkey.bind(move_mods, "down", move_down, nil, move_down)
  end

  -- Window resizing bindings
  if resize_mods and #resize_mods > 0 then
    local resize_left = function()
      self.grid:resizeWin(hs.window.focusedWindow(), p(-1, 0))
    end

    local resize_right = function()
      self.grid:resizeWin(hs.window.focusedWindow(), p(1, 0))
    end

    local resize_up = function()
      self.grid:resizeWin(hs.window.focusedWindow(), p(0, -1))
    end

    local resize_down = function()
      self.grid:resizeWin(hs.window.focusedWindow(), p(0, 1))
    end

    hs.hotkey.bind(resize_mods, "left", resize_left, nil, resize_left)
    hs.hotkey.bind(resize_mods, "right", resize_right, nil, resize_right)
    hs.hotkey.bind(resize_mods, "up", resize_up, nil, resize_up)
    hs.hotkey.bind(resize_mods, "down", resize_down, nil, resize_down)
  end

  -- Fixed position bindings
  if move_mods and #move_mods > 0 then
    -- 3x1 grid - thirds
    hs.hotkey.bind(move_mods, "1", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x,
        y = screen.y,
        w = screen.w / 3,
        h = screen.h
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, "2", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x + screen.w / 3,
        y = screen.y,
        w = screen.w / 3,
        h = screen.h
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, "3", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x + 2 * screen.w / 3,
        y = screen.y,
        w = screen.w / 3,
        h = screen.h
      }
      win:setFrame(frame)
    end)

    -- 2x2 grid - quarters
    hs.hotkey.bind(move_mods, "o", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x,
        y = screen.y,
        w = screen.w / 2,
        h = screen.h / 2
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, "p", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x + screen.w / 2,
        y = screen.y,
        w = screen.w / 2,
        h = screen.h / 2
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, "l", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x,
        y = screen.y + screen.h / 2,
        w = screen.w / 2,
        h = screen.h / 2
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, ";", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x + screen.w / 2,
        y = screen.y + screen.h / 2,
        w = screen.w / 2,
        h = screen.h / 2
      }
      win:setFrame(frame)
    end)

    -- 2x1 grid - halves
    hs.hotkey.bind(move_mods, "[", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x,
        y = screen.y,
        w = screen.w / 2,
        h = screen.h
      }
      win:setFrame(frame)
    end)

    hs.hotkey.bind(move_mods, "]", function()
      local win = hs.window.focusedWindow()
      if not win then return end
      local screen = win:screen():frame()
      local frame = {
        x = screen.x + screen.w / 2,
        y = screen.y,
        w = screen.w / 2,
        h = screen.h
      }
      win:setFrame(frame)
    end)
  end

  -- Move to next/previous screen
  hs.hotkey.bind(move_mods, "0", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    win:moveToScreen(win:screen():next())
  end)

  hs.hotkey.bind(move_mods, "9", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    win:moveToScreen(win:screen():previous())
  end)
end

return window_keyboard
