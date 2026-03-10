--- Run a function on the next server idle frame.
--
-- This is a small wrapper around `on_server_idle.lua`.
--
-- @module on_idle

local on_server_idle = luanti_utils.dofile('on_server_idle.lua')

--- Schedule a function to run when the server is idle.
--
-- @tparam function fn Function that receives `dtime` as its first argument.
local function on_idle(fn)
    on_server_idle(fn)
end

return on_idle
