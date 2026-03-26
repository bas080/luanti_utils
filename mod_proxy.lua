---
-- Better feedback when mod does not exist or is not enabled.
--
-- @module mod_proxy.lua
--
-- @tparam string modname
local function mod_proxy(modname)
  local modpath = core.get_modpath(modname)
  assert(modpath, modname .. ' is not installed or is not enabled')
  return dofile(core.get_modpath(modname)..'/init.lua')
end

return mod_proxy
