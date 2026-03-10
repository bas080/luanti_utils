--- Helper for scheduling work to run when the server is idle.
--
-- This module is used by other utilities in this repo to defer work until the
-- server has spare time.
--
-- @module run_when_idle

local on_server_idle = luanti_utils.dofile('on_server_idle.lua')

local M = {}

--- Schedule a function to run when the server is idle.
--
-- @tparam function fn Function that receives `dtime` as its first argument.
function M.run(fn)
    on_server_idle(fn)
end

return M
