--- Idle-time runner for a Task_queue.
-- Gradually executes queued jobs only when the server has spare time.
-- @module run_when_idle_scheduler
-- @tparam table task_queue Task_queue instance (from Task_queue(queue))
-- @treturn table Scheduler API with `is_idle`, `is_busy`, and `size` fields
local function Server_idle_task_queue_scheduler(task_queue)
    local M = {}

    local TARGET_STEP = 0.1
    local EMA_ALPHA = 0.1
    local SAFETY_MARGIN = 0.005
    local SPARE_FRACTION = 0.5
    local AVG_JOB_TIME = 0.001

    local avg_dtime = TARGET_STEP

    M.is_idle = true
    M.is_busy = false
    M.size = 0

    core.register_globalstep(function(dtime)
        avg_dtime = avg_dtime + EMA_ALPHA * (dtime - avg_dtime)

        local spare = TARGET_STEP - avg_dtime
        local budget = (spare - SAFETY_MARGIN) * SPARE_FRACTION

        M.is_idle = budget > 0
        M.is_busy = not M.is_idle

        if M.is_busy or task_queue.queue:is_empty() then
            return
        end

        local jobs_to_run = math.max(1, math.floor(budget / AVG_JOB_TIME))

        for _ = 1, jobs_to_run do
            task_queue.run()
        end

        M.size = task_queue.queue:size()
    end)

    return M
end

return Server_idle_task_queue_scheduler
