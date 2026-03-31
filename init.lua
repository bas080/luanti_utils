--- Luanti init.lua for `luanti_utils`.
--
-- Defines a global named luanti_utils with the following:
--
-- @module init.lua

local modpath = core.get_modpath(core.get_current_modname())

--- The global luanti_utils table.
luanti_utils = {}

local dofile_cache = {}

--- Load a Lua file from the current mod directory.
--
-- This is a wrapper around `dofile` that automatically prepends the
-- mod's path, so you can load other files in your mod without
-- specifying the full path manually.
--
-- @tparam string module The filename of the Lua module to load (relative to the luanti_utils directory)
-- @treturn any The return value of the loaded module
--
-- @usage
-- local extend_item = luanti_utils.dofile("extend_item.lua")
-- local extend_group = luanti_utils.dofile("extend_group.lua")
function luanti_utils.dofile(module)
	if dofile_cache[module] then
		return dofile_cache[module]
	end

	local value = dofile(modpath .. "/" .. module)

	if not luanti_utils._nocache then
		dofile_cache[module] = value
	end

	luanti_utils._nocache = false

	return value
end

luanti_utils._nocache = false

---
--
-- A function that is called in luanti_util modules that should not cache.
--
-- By default luanti\_utils modules are cached which is unusual for a dofile but
-- a pretty handy default when writing modules. For the user of luanti\_utils it
-- does not matter. Only for luanti_utils developers it's important to know.
--
-- @function luanti_utils.nocache
--
-- @see debug.lua
function luanti_utils.nocache()
	luanti_utils._nocache = true
end
