---
-- @module register_timer.lua
--
-- @usage
-- local after = register_timer({
--   name = "hello",
--   action = function(name)
--     print("Hello " .. name)
--   end
-- })
--
-- local cancel = after(5 "world")
--
-- cancel()
--
-- @see https://github.com/bas080/register_timer

local mod_proxy = luanti_utils.dofile('mod_proxy.lua')

return mod_proxy('register_timer')
