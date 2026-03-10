--- Run tasks when the server is idle (spread work across globalsteps).
--
-- This module provides a simple mechanism to queue work and execute it only
-- when the globalstep has spare time, helping avoid lag spikes.
--
-- @module on_server_idle

local queue = luanti_utils.dofile('queue.lua')

local TARGET_STEP = 0.1
local EMA_ALPHA = 0.1
local SAFETY_MARGIN = 0.005
local SPARE_FRACTION = 0.5
local AVG_JOB_TIME = 0.001

local avg_dtime = TARGET_STEP

-- Attach state to the function itself
on_server_idle.is_idle = true
on_server_idle.is_busy = false

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

--- Schedule a task to run when the server is idle.
--
-- The provided function will be invoked in a later globalstep, depending on
-- how much spare time is available.
--
-- @tparam function task_fn Function receiving `dtime` as the first argument.
local function on_server_idle(task_fn)
    queue.push(task_fn)
end

return on_server_idle
