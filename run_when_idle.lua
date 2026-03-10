--- Idle-time job scheduler for Luanti / Minetest.
-- Runs queued work only when the server step has spare time.
-- The module estimates spare time from `globalstep` dtime using
-- an exponential moving average and executes queued jobs gradually
-- within the available budget.
--
-- This allows expensive or batch work to be spread across many
-- server steps without causing lag spikes.
--
-- In addition to the queued execution API, the module exposes a
-- fast synchronous hint (`is_idle`) that allows callers to decide
-- whether to run work immediately without using the queue.
--
-- @module run_when_idle
local M = {}


local make_queue = luanti_utils.dofile('make_queue.lua')

local TARGET_STEP = 0.1
local EMA_ALPHA = 0.1
local SAFETY_MARGIN = 0.005
local SPARE_FRACTION = 0.5
local AVG_JOB_TIME = 0.001

local avg_dtime = TARGET_STEP
local max_fns = 1000000

local queue = make_queue(max_fns)

--- Indicates whether the server currently has spare time.
--
-- This flag is updated every `globalstep` and represents a quick
-- estimate of whether the server step still has execution budget.
--
-- It can be used for **synchronous checks** when the caller wants
-- to opportunistically perform work immediately instead of placing
-- it in the queue.
--
-- This avoids queue overhead and is useful for very small tasks
-- or logic already running in a hot path.
--
-- @tfield boolean is_idle True if spare time is currently available.
M.is_idle = true


--- Opposite of `is_idle`.
--
-- Provided for readability in conditional logic.
--
-- @tfield boolean is_busy True when the server step is considered busy.
--
-- @usage
-- if run_when_idle.is_idle then
--     do_small_job()
-- else
--     run_when_idle.run(do_small_job)
-- end
M.is_busy = false

M.size = 0

--- Queue a function to run when the server has spare time.
--
-- The function will be executed during a future `globalstep`
-- when the scheduler determines that there is enough spare
-- time available in the current step.
--
-- Jobs are processed FIFO and executed gradually based on
-- an estimated per-job runtime (`AVG_JOB_TIME`).
--
-- If the queue is full the job is dropped and an error is logged.
--
-- @tparam function fn Function to execute later during idle time.
-- @usage
-- run_when_idle.run(function()
--     do_expensive_work()
-- end)
-- 
function M.run(fn)
    if type(fn) ~= "function" then
        error("run_when_idle expects a function", 2)
    end

    if not queue.push(fn) then
        core.log("error", "[run_when_idle] max jobs reached, dropping this one")
    end
end

core.register_globalstep(function(dtime)
    avg_dtime = avg_dtime + EMA_ALPHA * (dtime - avg_dtime)

    local spare = TARGET_STEP - avg_dtime
    local budget = (spare - SAFETY_MARGIN) * SPARE_FRACTION

    M.is_idle = budget > 0
    M.is_busy = not M.is_idle

    if queue.is_empty() or M.is_busy then
        return
    end

    local jobs_to_run = math.max(1, math.floor(budget / AVG_JOB_TIME))

    for _ = 1, jobs_to_run do
        local fn = queue.pop()
        if not fn then break end
        fn()
    end

    M.size = queue.size()

    core.log('info', 'Ran '..jobs_to_run ..'. '..queue.size() .. ' jobs on the queue.')

end)

return M
