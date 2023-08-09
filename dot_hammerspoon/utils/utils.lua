--[[ LOGIC ]]

---@param x number
---@return integer
local function sign(x)
	return x > 0 and 1 or x < 0 and -1 or 0
end

---@param x number
---@param x1 number
---@param x2 number
---@return number
local function clip(x, x1, x2)
	return  x < x1 and x1 or x > x2 and x2 or x
end

--[[ MODULE ]]

return {
	sign=sign,
	clip=clip,
}
