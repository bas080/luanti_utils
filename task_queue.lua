--- Factory function for a task queue bound to a specific queue instance.
-- Allows registering named tasks and adding jobs with arbitrary arguments.
-- Jobs are stored in the provided queue as `{name=..., args={...}}`.
-- @module task_queue
-- @tparam table queue Queue instance to use (must implement push/pop/is_empty/size)
-- @treturn table Task queue API with `register_task` and `run` methods
local function Task_queue(queue)
    local M = {}
    local handlers = {}

    --- Register a task with a name.
    -- Returns a function that adds jobs of this type to the queue with arbitrary arguments.
    -- @tparam string name Task name.
    -- @tparam function fn Function to handle task arguments: fn(...)
    -- @treturn function add_task(...) Pushes a job with arbitrary args.
    function M.register_task(name, fn)
        handlers[name] = fn

        --- Add a job to the queue for this task.
        -- @param ... Arbitrary arguments passed to the handler when the job runs.
        local function add_task(...)
            local args = {...}
            if not queue.push({name = name, args = args}) then
                core.log("error", "[run_when_idle] queue full, dropping task: "..name)
            end
        end

        return add_task
    end

    --- Run the next job in the queue.
    -- Pops a job and calls its registered handler with the stored arguments.
    function M.run()
        local job = queue.pop()

        if job then
            local handler = handlers[job.name]

            if handler then
                handler(table.unpack(job.args))
            end
        end
    end

    return M
end

return Task_queue
