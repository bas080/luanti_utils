--- Run tasks when the server is idle (spread work across globalsteps).
--
-- This module provides a simple mechanism to queue work and execute it only
-- when the globalstep has spare time, helping avoid lag spikes.
--
-- The module exposes two main interfaces:
-- 1. A wrapper function to defer execution of a function.
-- 2. A `.run` method to schedule a task immediately in the idle queue.
--
-- @module on_server_idle

local queue = luanti_utils.dofile('queue.lua')
local noop = luanti_utils.dofile('noop')

local TARGET_STEP = 0.1
local EMA_ALPHA = 0.1
local SAFETY_MARGIN = 0.005
local SPARE_FRACTION = 0.5
local AVG_JOB_TIME = 0.001

local avg_dtime = TARGET_STEP


core.register_globalstep(function(dtime)
    avg_dtime = avg_dtime + EMA_ALPHA * (dtime - avg_dtime)

    if queue.is_empty() then
        return
    end

    local spare = TARGET_STEP - avg_dtime
    local budget = (spare - SAFETY_MARGIN) * SPARE_FRACTION

    on_server_idle.is_idle = budget > 0
    on_server_idle.is_busy = not on_server_idle.is_idle

    if on_server_idle.is_busy then return end

    local jobs_to_run = math.max(1, math.floor(budget / AVG_JOB_TIME))

    for _ = 1, jobs_to_run do
        queue.pop()(dtime)
    end
end)

--- Wrap a function so that it runs when the server is idle.
--
-- Returns a new function which, when called, schedules the original
-- function to run later with any given arguments.
--
-- @tparam function fn Function to wrap.
-- @treturn function Wrapped function that schedules `fn` on idle.
local function on_server_idle(fn)
    return function(...)
        on_server_idle.run(function()
            fn(...)
        end)
    end
end

--- Schedule a task to run when the server is idle.
--
-- The provided function will be invoked in a later globalstep, depending on
-- how much spare time is available.
--
-- @tparam function task_fn Function receiving `dtime` as the first argument.
function on_server_idle.run(task_fn)
    queue.push(task_fn)
end

--- Current idle state of the server.
-- True when the idle queue has budget to run tasks.
-- @tfield bool is_idle
-- @tfield bool is_busy
on_server_idle.is_idle = true
on_server_idle.is_busy = false

return on_server_idle
