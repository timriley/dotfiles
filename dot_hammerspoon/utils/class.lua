
---@class Class
---@field __name string
---@field __base Class?
---@field __props table<string, boolean>
---@field __cls Class

-------------------------------------------------------------------------------

---@param cls Class
---@return table
local function __object_new(cls, ...)
	local obj = {}
	setmetatable(obj, cls)
	obj:__init(...)
	return obj
end

---@param cls Class
---@return string
local function __cls_tostring(cls)
	return "class " .. cls.__name
end

-------------------------------------------------------------------------------

---@param cls Class
---@param self table
---@param k string
---@return any
local function __instance_index(cls, self, k)
	if k == "__cls" then
		return cls

	elseif cls.__props[k] then
		local func = cls["get_" .. k]
		if not func then
			error(
				"reading property " .. k
				.. " in class " .. cls.__name
				.. " is not implemented"
			)
		end
		return func(self)

	else
		return rawget(cls, k)
	end
end

---@param cls Class
---@param self table
---@param k string
---@param v any
local function __instance_newindex(cls, self, k, v)
	if k == "__cls" then
		error("cannot set " .. cls.__name .. ".__cls")

	elseif cls.__props[k] then
		local func = cls["set_" .. k]
		if not func then
			error(
				"writing property " .. k
				.. " in class " .. cls.__name
				.. " is not implemented"
			)
		end
		func(self, v)

	else
		rawset(self, k, v)
	end
end

-------------------------------------------------------------------------------

---@alias ClassKwargs {base_cls: Class?, props: string[]? }

---@param cls_name string
---@param kwargs ClassKwargs
---@return Class
local function _make_class(cls_name, kwargs)
	local kwargs_base_cls = kwargs.base_cls
	kwargs.base_cls = nil

	local cls = {}
	for k, v in pairs(kwargs_base_cls or {}) do
		cls[k] = v
	end
	cls.__name = cls_name
	cls.__base = kwargs_base_cls

	cls.__props = {}
	for prop_name, _ in pairs((kwargs_base_cls or {}).__props or {}) do
		cls.__props[prop_name] = true
	end

	local kwargs_props = kwargs.props
	kwargs.props = nil
	for _, prop_name in ipairs(kwargs_props or {}) do
		cls.__props[prop_name] = true
	end

	for kwarg_k, kwarg_v in pairs(kwargs) do
		cls[kwarg_k] = kwarg_v
	end

	---@param k string
	---@return any
	function cls:__index(k)
		return __instance_index(cls, self, k)
	end

	---@param k string
	---@param v any
	function cls:__newindex(k, v)
		__instance_newindex(cls, self, k, v)
	end

	setmetatable(cls, {
		__call=__object_new,
		__tostring=function () return __cls_tostring(cls) end,
	})

	return cls
end

-------------------------------------------------------------------------------

local Object = _make_class("Object", {})

function Object:__init()
end

---@return string
function Object:__tostring()
	return self.__cls.__name .. " instance"
end

-------------------------------------------------------------------------------

---@param name string
---@param kwargs ClassKwargs?
---@return Class
local function class(name, kwargs)
	kwargs = kwargs or {}
	kwargs.base_cls = kwargs.base_cls or Object
	return _make_class(name, kwargs)
end

---@param cls1 Class
---@param cls2 Class
---@return boolean
local function is_subclass(cls1, cls2)
	local c = cls1
	while c do
		if c == cls2 then
			return true
		end
		c = c.__base
	end
	return false
end

---@param obj any
---@param cls Class
---@return boolean
local function is_instance(obj, cls)
	return is_subclass(obj.__cls, cls)
end

local module = {
	Object=Object,
	is_instance=is_instance,
	is_subclass=is_subclass,
}
local function _module_call(t, ...)
	return class(...)
end
setmetatable(module, {__call=_module_call})

return module
