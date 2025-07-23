local SnapValues = {}
SnapValues.__index = SnapValues

-- Create a new SnapValues instance
function SnapValues.new(min_value, max_value, snap_threshold)
  local self = setmetatable({}, SnapValues)
  self.min_value = min_value
  self.max_value = max_value
  self.snap_threshold = snap_threshold
  self.buckets = {}
  return self
end

-- Add a value to snap to
function SnapValues:add(value)
  if value < self.min_value then return end
  if value > self.max_value then return end

  local buckets = self.buckets
  local mid_bucket = math.floor(value / self.snap_threshold)

  -- Add the value to the bucket and adjacent buckets to ensure we catch it
  for b = mid_bucket - 1, mid_bucket + 1 do
    if not buckets[b] then buckets[b] = {} end
    buckets[b][value] = true
  end
end

-- Query for a value to snap to
function SnapValues:query(q)
  local bucket = math.floor(q / self.snap_threshold)
  for value, _ in pairs(self.buckets[bucket] or {}) do
    local delta = value - q
    if math.abs(delta) <= self.snap_threshold then
      return value, delta
    end
  end
  return nil, nil
end

return SnapValues
