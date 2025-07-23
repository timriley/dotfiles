local window_grid = {}

-- Size class for 2D dimensions
local Size = {}
function Size:new(w, h)
  local obj = { w = w, h = h }
  setmetatable(obj, { __index = self })
  return obj
end

-- Point class for 2D coordinates
local Point = {}
function Point:new(x, y)
  local obj = { x = x, y = y }
  setmetatable(obj, { __index = self })
  return obj
end

-- Helper function to check if a point is close to a value
local function isCloseTo(value, target, threshold)
  threshold = threshold or 1
  return math.abs(value - target) <= threshold
end

-- Main WinGrid class
local WinGrid = {}

function WinGrid:new(grid_size)
  local obj = { grid_size = grid_size }
  setmetatable(obj, { __index = self })
  return obj
end

function WinGrid:gridForWin(win)
  local screen_frame = win:screen():frame()
  local cell_width = math.floor(screen_frame.w / self.grid_size.w)
  local cell_height = math.floor(screen_frame.h / self.grid_size.h)

  return {
    frame = screen_frame,
    cell_size = Size:new(cell_width, cell_height),

    -- Move the window by delta cells
    moveAndSnap = function(self, frame, delta)
      -- Don't constrain horizontal movement to screen bounds to allow off-screen positioning
      local new_x = self:_adjustAndSnap(frame.x, delta.x, self.cell_size.w)
      local new_y = self:_adjustAndSnap(frame.y, delta.y, self.cell_size.h, self.frame.y, self.frame.y + self.frame.h)
      return { x = new_x, y = new_y }
    end,

    -- Resize the window by delta cells
    resizeAndSnap = function(self, frame, delta)
      local new_right = self:_adjustAndSnap(frame.x + frame.w, delta.x, self.cell_size.w)
      local new_bottom = self:_adjustAndSnap(frame.y + frame.h, delta.y, self.cell_size.h)
      return { x = new_right, y = new_bottom }
    end,

    -- Helper function to adjust a coordinate and snap to grid
    _adjustAndSnap = function(self, pos, delta, cell_size, min, max)
      if not delta or delta == 0 then return pos end

      local move_dir = delta > 0 and 1 or -1
      local delta_abs = math.abs(delta)

      local cell_idx = math.floor((pos - (self.frame.x)) / cell_size)
      local cell_start = self.frame.x + cell_idx * cell_size

      if isCloseTo(pos, cell_start + (move_dir > 0 and cell_size or 0)) then
        cell_idx = cell_idx + move_dir
      end

      local new_cell_idx = cell_idx + move_dir * (delta_abs - 1)
      local new_pos = self.frame.x + new_cell_idx * cell_size + (move_dir > 0 and cell_size or 0)

      -- Only apply min/max constraints if they are provided
      -- This allows moving windows off-screen when constraints are not passed
      if min and max then
        new_pos = math.max(min, math.min(max, new_pos))
      end

      return new_pos
    end
  }
end

function WinGrid:moveWin(win, delta)
  if not win then return end

  local win_frame = win:frame()
  local grid = self:gridForWin(win)
  local new_topleft = grid:moveAndSnap(win_frame, delta)

  win_frame.x = new_topleft.x
  win_frame.y = new_topleft.y

  win:setFrame(win_frame)
end

function WinGrid:resizeWin(win, delta)
  if not win then return end

  local win_frame = win:frame()
  local grid = self:gridForWin(win)
  local new_bottomright = grid:resizeAndSnap(win_frame, delta)

  win_frame.w = new_bottomright.x - win_frame.x
  win_frame.h = new_bottomright.y - win_frame.y

  win:setFrame(win_frame)
end

function WinGrid:centerWin(win, center_horiz, center_vert)
  if not win then return end

  local screen_frame = win:screen():frame()
  local win_frame = win:frame()

  if center_horiz then
    win_frame.x = screen_frame.x + (screen_frame.w - win_frame.w) / 2
  end

  if center_vert then
    win_frame.y = screen_frame.y + (screen_frame.h - win_frame.h) / 2
  end

  win:setFrame(win_frame)
end

function WinGrid:maximizeWin(win, maximize_horiz, maximize_vert)
  if not win then return end

  local screen_frame = win:screen():frame()
  local win_frame = win:frame()

  if maximize_horiz then
    win_frame.x = screen_frame.x
    win_frame.w = screen_frame.w
  end

  if maximize_vert then
    win_frame.y = screen_frame.y
    win_frame.h = screen_frame.h
  end

  win:setFrame(win_frame)
end

-- Create the module interface
window_grid.createGrid = function(width, height)
  return WinGrid:new(Size:new(width, height))
end

window_grid.createPoint = function(x, y)
  return Point:new(x, y)
end

return window_grid
