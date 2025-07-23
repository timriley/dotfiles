-- window_utils.lua
-- Utility functions for working with windows

local window_utils = {}

-- Get all visible windows on the system
function window_utils.getVisibleWindows()
  local result = {}
  for _, app in pairs(hs.application.runningApplications()) do
    if app:kind() > 0 and not app:isHidden() then
      for _, w in ipairs(app:visibleWindows()) do
        table.insert(result, w)
      end
    end
  end
  return result
end

-- Get windows in stacking order (front to back)
function window_utils.getOrderedWindows()
  local win_set = {}
  for _, w in ipairs(window_utils.getVisibleWindows()) do
    win_set[w:id() or -1] = w
  end

  local result = {}
  for _, win_id in ipairs(hs.window._orderedwinids()) do
    if win_set[win_id] then
      table.insert(result, win_set[win_id])
    end
  end
  return result
end

-- Get the window under the mouse pointer
function window_utils.getWindowUnderPointer()
  local mouse_pos = hs.geometry(hs.mouse.absolutePosition())
  local mouse_screen = hs.mouse.getCurrentScreen()

  local result = hs.fnutils.find(window_utils.getOrderedWindows(), function(w)
    return (
      w:screen() == mouse_screen
      and w:isStandard()
      and mouse_pos:inside(w:frame())
    )
  end)
  return result
end

-- Debug function to print all windows
function window_utils.dumpWindowsList()
  for _, w in ipairs(hs.window.allWindows()) do
    print(
      w:id(),
      w:application():name(),
      w:title(),
      w:role(),
      w:subrole(),
      w:isStandard()
    )
  end
end

return window_utils
