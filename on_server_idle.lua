--- Run tasks when the server is idle (spread work across globalsteps).
--
-- This module provides a simple mechanism to queue work and execute it only
-- when the globalstep has spare time, helping avoid lag spikes.
--
-- @module on_server_idle.lua

--- Module table
-- @table on_server_idle
-- @tfield wrap wrap
-- @tfield run run
-- @tfield boolean is_idle True when the idle queue has budget to run tasks.
-- @tfield boolean is_busy False when idle
local M = {}

local Queue = luanti_utils.dofile('queue.lua')

local TARGET_STEP = 0.1
local EMA_ALPHA = 0.1
local SAFETY_MARGIN = 0.005
local SPARE_FRACTION = 0.5
local AVG_JOB_TIME = 0.001

local avg_dtime = TARGET_STEP

local queue = Queue()

core.register_globalstep(function(dtime)
    avg_dtime = avg_dtime + EMA_ALPHA * (dtime - avg_dtime)

    if queue.is_empty() then
        return
    end

    local spare = TARGET_STEP - avg_dtime
    local budget = (spare - SAFETY_MARGIN) * SPARE_FRACTION

    M.is_idle = budget > 0
    M.is_busy = not M.is_idle

    if M.is_busy then return end

    local jobs_to_run = math.max(1, math.floor(budget / AVG_JOB_TIME))

    for _ = 1, jobs_to_run do
        -- Could have no jobs
        local fn = queue.pop()

        if fn then
            fn(dtime)
        else
            break
        end
    end
end)

--- Wrap a function so that it runs when the server is idle.
--
-- Returns a new function which, when called, schedules the original
-- function to run later with any given arguments.
-- @function on_server_idle.wrap
--
-- @tparam function task_fn Function to wrap.
-- @treturn function Wrapped function that schedules `fn` on idle.
function M.wrap(task_fn)
    return function(...)
        local args = {...}
        M.run(function()
            task_fn(table.unpack(args))
        end)
    end
end

--- Schedule a task to run when the server is idle.
--
-- The provided function will be invoked in a later globalstep, depending on
-- how much spare time is available.
-- @function on_server_idle.run
--
-- @tparam function task_fn Function receiving `dtime` as the first argument.
function M.run(task_fn)
    queue.push(task_fn)
end

M.is_idle = true
M.is_busy = false

---
-- @treturn on_server_idle
return M
