--- Reduce a table asynchronously using idle callbacks.
--
-- This helper uses `on_server_idle.lua` to process each element over multiple frames,
-- preventing long-running loops from causing lag.
--
-- @module on_server_idle_reduce

local on_server_idle = luanti_utils.dofile('on_server_idle.lua')

--- Asynchronously reduce a table.
--
-- @tparam table tbl Table to reduce.
-- @tparam function fn Reduction function `(acc, item) -> acc`.
-- @param acc Initial accumulator value.
-- @tparam[opt] function done Optional callback called with the final accumulator.
-- @treturn table Job object with a `cancel()` method.
local function reduce(tbl, fn, acc, done)
    local job = {}
    local running, i = true, 1

    function job:cancel() running = false end

    local function step()
        if not running then return end
        if i > #tbl then
            if done then done(acc) end
            return
        end
        local item = tbl[i]
        i = i + 1
        on_server_idle(function()
            if not running then return end
            acc = fn(acc, item)
            step()
        end)
    end

    step()
    return job
end

return reduce
