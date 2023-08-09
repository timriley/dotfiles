local _NS_PER_SEC = 1000000000

--[[ LOGIC ]]

---@alias AnimData table<string, any[]>
---@alias AnimStepData table<string, any>
---@alias AnimStepFunc fun(step_data: AnimStepData, i_step: number)

---@param anim_data AnimData
---@param duration number
---@param step_func AnimStepFunc
---@param done_func fun()?
---@param frame_rate number?
local function animate(anim_data, duration, step_func, done_func, frame_rate)
	frame_rate = frame_rate or 60
	local frame_duration = 1 / frame_rate
	local i_frame = 0
	local t0 = hs.timer.absoluteTime() / _NS_PER_SEC
	local t1 = t0 + duration

	local function anim_step()
		local curr_timestamp = hs.timer.absoluteTime() / _NS_PER_SEC
		local t = (curr_timestamp - t0) / duration
		t = t <= 1 and t or 1

		local fn_anim_data = {}
		for k, v in pairs(anim_data) do
			local v0, v1 = table.unpack(v)
			fn_anim_data[k] = v0 + t * (v1 - v0)
		end
		step_func(fn_anim_data, t)

		if curr_timestamp >= t1 then
			if done_func then
				done_func()
			end
			return
		end

		i_frame = i_frame + 1
		local next_timestamp = t0 + i_frame * frame_duration
		local delay = next_timestamp - curr_timestamp
		delay = delay >= 0 and delay or 0
		hs.timer.doAfter(delay, anim_step)
	end
	hs.timer.doAfter(0, anim_step)
end

--[[ MODULE ]]

return {
	animate=animate,
}
