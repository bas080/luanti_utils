--- Utility functions for the `luanti_utils` module.
--
-- Provides helpers for loading files relative to the current mod path.
--
-- @module luanti_utils

local modpath = core.get_modpath(core.get_current_modname())

--- The module table
luanti_utils = {}

--- Load a Lua file from the current mod directory.
--
-- This is a wrapper around `dofile` that automatically prepends the
-- mod's path, so you can load other files in your mod without
-- specifying the full path manually.
--
-- @tparam string module The filename of the Lua module to load (relative to the mod folder)
-- @treturn any The return value of the loaded module
--
-- @usage
-- local extend_item = luanti_utils.dofile("extend_item.lua")
-- local extend_group = luanti_utils.dofile("extend_group.lua")
function luanti_utils.dofile(module)
  return dofile(modpath .. '/' .. module)
end
