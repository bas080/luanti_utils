--- Asynchronous reduction over a table using idle callbacks.
--
-- This helper iterates over a table by scheduling each step on idle frames.
-- It is useful for processing large tables without causing lag.
--
-- @module async_reduce

local on_idle = luanti_utils.dofile('on_idle.lua')

--- Reduce a table value asynchronously.
--
-- @tparam table tbl Table to iterate over.
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
        on_idle(function()
            if not running then return end
            acc = fn(acc, item)
            step()
        end)
    end

    step()
    return job
end

return reduce
