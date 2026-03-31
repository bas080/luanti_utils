---
-- @module debug.lua
--
-- Prints debug statement with milliseconds since last log and the modname prefixed.
--
-- Requires env variable DEBUG to be set to any value. In future might support passing a string(s) to match on.
--
-- @tparam any ...
-- @treturn nil
luanti_utils.nocache()

local noop = luanti_utils.dofile("noop.lua")

if os.getenv("DEBUG") == nil then
	return noop
end

local last_clock = os.clock() * 1000
local modname = core.get_current_modname()

local function debug(...)
	local new_clock = os.clock() * 1000
	local elapsed = new_clock - last_clock
	last_clock = new_clock

	print("[" .. modname .. "]" .. math.floor(elapsed) .. "ms\t" .. dump({ ... }))
end

return debug
