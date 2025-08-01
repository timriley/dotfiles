local window_utils = require("utils.window_utils")
local SnapValues = require("snap_values")

local window_mouse = {}

-- Constants
local SNAP_THRESHOLD = 10

-- Internal state
local drag_state = {
  mode = nil,              -- "move" or "resize"
  win = nil,               -- window being dragged
  screen = nil,            -- screen containing the window
  screen_frame = nil,      -- frame of the screen
  win_initial_frame = nil, -- initial frame of the window
  initial_mouse_pos = nil, -- mouse position when drag started
  edge_idx = nil,          -- which edge is being dragged
  other_edge_idx = nil,    -- opposite edge
  really_started = false,  -- true once mouse has moved enough to start the drag
  do_snap = true,          -- snap to screen edges
  snap_values = nil        -- snap values
}

function window_mouse:init(config)
  self.config = config or {}
  self.config.move_mods = self.config.move_mods or { "ctrl", "cmd" }
  self.config.resize_mods = self.config.resize_mods or { "ctrl", "alt" }
  self.config.resize_only_bottom_right = (self.config.resize_only_bottom_right ~= false)

  hs.window.animationDuration = 0

  -- Create event watchers
  self.kbd_mods_event_tap = hs.eventtap.new(
    { hs.eventtap.event.types.flagsChanged },
    function(e) return self:_kbd_mods_event_handler(e) end
  )

  self.drag_event_tap = hs.eventtap.new(
    { hs.eventtap.event.types.mouseMoved },
    function(e) return self:_drag_event_handler(e) end
  )
end

-- Start listening for keyboard events
function window_mouse:start()
  self.kbd_mods_event_tap:start()
end

-- Begin dragging a window
function window_mouse:_start_drag(mode)
  -- Stop any existing drag
  self:_stop_drag()

  -- Get window under pointer
  local win = window_utils.getWindowUnderPointer()
  if not win then return end

  -- Initialize drag state
  drag_state.mode = mode
  drag_state.win = win
  drag_state.screen = win:screen()
  drag_state.screen_frame = win:screen():frame()
  drag_state.win_initial_frame = win:frame()
  drag_state.initial_mouse_pos = hs.mouse.absolutePosition()
  drag_state.really_started = false
  drag_state.do_snap = true

  -- Determine which edge is being dragged
  if mode == "move" then
    drag_state.edge_idx = { x = 1, y = 1 }
  elseif mode == "resize" then
    local t = self.config.resize_only_bottom_right and 0.0 or 0.25
    local xt = drag_state.win_initial_frame.x + t * drag_state.win_initial_frame.w
    local yt = drag_state.win_initial_frame.y + t * drag_state.win_initial_frame.h

    drag_state.edge_idx = {
      x = drag_state.initial_mouse_pos.x < xt and 1 or 2,
      y = drag_state.initial_mouse_pos.y < yt and 1 or 2
    }
  end

  -- Calculate the opposite edge
  drag_state.other_edge_idx = {
    x = 3 - drag_state.edge_idx.x,
    y = 3 - drag_state.edge_idx.y
  }

  -- Start the drag event tap
  self.drag_event_tap:start()
end

-- End dragging
function window_mouse:_stop_drag()
  drag_state.mode = nil
  self.drag_event_tap:stop()

  -- Clean up snap values
  drag_state.snap_values = nil
end

-- Handle keyboard modifier changes
function window_mouse:_kbd_mods_event_handler(e)
  local mods = e:getFlags()

  -- Check if drag should stop
  if drag_state.mode then
    local mode_mods = drag_state.mode == "move" and self.config.move_mods or self.config.resize_mods
    if not mods:contain(mode_mods) then
      self:_stop_drag()
    end
    return
  end

  -- Check if drag should start
  if mods:contain(self.config.move_mods) then
    self:_start_drag("move")
  elseif mods:contain(self.config.resize_mods) then
    self:_start_drag("resize")
  end
end

-- Handle mouse movement during drag
function window_mouse:_drag_event_handler(e)
  if not drag_state.mode then return end

  -- Calculate mouse movement
  local mouse_pos = hs.mouse.absolutePosition()
  local mouse_dx = mouse_pos.x - drag_state.initial_mouse_pos.x
  local mouse_dy = mouse_pos.y - drag_state.initial_mouse_pos.y

  -- Don't start moving/resizing until the mouse has moved a bit
  if not drag_state.really_started then
    if math.abs(mouse_dx) < 3 and math.abs(mouse_dy) < 3 then
      return
    end
    self:_really_start_drag()
  end

  -- Create new frame based on the initial frame
  local new_frame = drag_state.win_initial_frame:copy()

  -- Update the frame based on mouse movement
  self:_update_frame_dim(new_frame, "x", "w", mouse_dx)
  self:_update_frame_dim(new_frame, "y", "h", mouse_dy)

  -- Apply snapping
  if drag_state.do_snap then
    self:_snap_frame(new_frame)
  end

  -- Apply the new frame to the window
  drag_state.win:setFrame(new_frame)
end

-- Start the drag for real (focus window, create snap values)
function window_mouse:_really_start_drag()
  -- Focus the window being dragged
  drag_state.win:focus()

  -- Create snap values for screen edges
  if drag_state.do_snap then
    drag_state.snap_values = self:_snap_values_for_window(drag_state.win)
  end

  drag_state.really_started = true
end

-- Update a frame dimension based on mouse movement
function window_mouse:_update_frame_dim(new_frame, dim_name, size_name, delta)
  local edge_idx = drag_state.edge_idx[dim_name]
  local edge_name = dim_name .. edge_idx

  -- Move mode just shifts the window
  if drag_state.mode == "move" then
    new_frame[edge_name] = new_frame[edge_name] + delta
    return
  end

  -- Resize mode changes the size of the window
  local edge_1_name = dim_name .. "1"
  local edge_2_name = dim_name .. "2"

  local initial_edge_1_value = drag_state.win_initial_frame[edge_1_name] or drag_state.win_initial_frame.x
  local initial_edge_2_value = drag_state.win_initial_frame[edge_2_name] or
      drag_state.win_initial_frame.y + drag_state.win_initial_frame.h

  local new_edge_1_value = new_frame[edge_1_name] or new_frame.x
  local new_edge_2_value = new_frame[edge_2_name] or new_frame.y + new_frame.h

  if edge_idx == 1 then
    new_edge_1_value = new_edge_1_value + delta
  else
    new_edge_2_value = new_edge_2_value + delta
  end

  local new_size = new_edge_2_value - new_edge_1_value

  -- Enforce minimum window size
  local min_size = 75
  if new_size >= min_size then
    if edge_idx == 1 then
      if dim_name == "x" then
        new_frame.x = new_edge_1_value
      else
        new_frame.y = new_edge_1_value
      end
    end

    new_frame[size_name] = new_size

    -- Keep window on screen when resizing from left or top
    if edge_idx == 1 then
      local screen_edge = drag_state.screen_frame[edge_1_name] or drag_state.screen_frame.x
      if new_frame[edge_1_name] < screen_edge then
        new_frame[edge_1_name] = screen_edge
        if edge_idx == 1 then
          if dim_name == "x" then
            new_frame.w = initial_edge_2_value - screen_edge
          else
            new_frame.h = initial_edge_2_value - screen_edge
          end
        end
      end
    end
  else
    -- If window would be too small, enforce minimum size
    new_frame[size_name] = min_size

    if edge_idx == 1 then
      if dim_name == "x" then
        new_frame.x = initial_edge_2_value - min_size
      else
        new_frame.y = initial_edge_2_value - min_size
      end
    end
  end
end

-- Apply snapping to the frame
function window_mouse:_snap_frame(new_frame)
  if not drag_state.snap_values then return end

  -- Determine what to snap (depends on whether we're moving or resizing)
  local edge_x = drag_state.edge_idx.x == 1 and "x" or "x2"
  local edge_y = drag_state.edge_idx.y == 1 and "y" or "y2"

  -- Query for snap values
  local snap_value_x, snap_delta_x = drag_state.snap_values.x:query(new_frame[edge_x])
  local snap_value_y, snap_delta_y = drag_state.snap_values.y:query(new_frame[edge_y])

  -- When moving, try to snap the other edge if the main edge doesn't snap
  if drag_state.mode == "move" then
    local other_edge_x = drag_state.other_edge_idx.x == 1 and "x" or "x2"
    local other_edge_y = drag_state.other_edge_idx.y == 1 and "y" or "y2"

    if snap_value_x == nil then
      snap_value_x, snap_delta_x = drag_state.snap_values.x:query(new_frame[other_edge_x])
    end

    if snap_value_y == nil then
      snap_value_y, snap_delta_y = drag_state.snap_values.y:query(new_frame[other_edge_y])
    end
  end

  -- Adjust frame to snap to edges
  self:_update_frame_dim(new_frame, "x", "w", snap_delta_x or 0)
  self:_update_frame_dim(new_frame, "y", "h", snap_delta_y or 0)
end

-- Create snap values for screen edges
function window_mouse:_snap_values_for_window(win)
  local screen = win:screen()
  local screen_frame = screen:frame()

  local snap_values_x = SnapValues.new(screen_frame.x, screen_frame.x + screen_frame.w, SNAP_THRESHOLD)
  local snap_values_y = SnapValues.new(screen_frame.y, screen_frame.y + screen_frame.h, SNAP_THRESHOLD)

  -- Add screen edges
  snap_values_x:add(screen_frame.x)
  snap_values_x:add(screen_frame.x + screen_frame.w)
  snap_values_x:add(screen_frame.x + screen_frame.w / 2)

  snap_values_y:add(screen_frame.y)
  snap_values_y:add(screen_frame.y + screen_frame.h)
  snap_values_y:add(screen_frame.y + screen_frame.h / 2)

  return {
    x = snap_values_x,
    y = snap_values_y
  }
end

return window_mouse
