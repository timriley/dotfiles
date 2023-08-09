--[[ STATE ]]

---@type PathWatcher?
local watcher = nil

--[[ LOGIC ]]

local function start()
	if watcher then return end
	watcher = hs.pathwatcher.new(hs.configdir, function ()
		hs.timer.doAfter(0.25, hs.reload)
	end)
	watcher:start()
end

local function stop()
	if not watcher then return end
	watcher:stop()
	watcher = nil
end

--[[ MODULE ]]

return {
	start=start,
	stop=stop,
}
