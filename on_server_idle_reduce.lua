--- Reduce a table asynchronously using idle callbacks.
--
-- This helper uses `on_server_idle.lua` to process each element over multiple frames,
-- preventing long-running loops from causing lag.
--
-- @module on_server_idle_reduce.lua
--
-- @tparam table tbl Table to reduce.
-- @tparam function on_item Reduction function `(acc, item) -> acc`.
-- @tparam acc Initial accumulator value.
-- @tparam[opt] on_done on_done Optional callback called with the final accumulator.
-- @treturn table Job object with a `cancel()` method.

--- Callbacks
-- @section Callbacks

--- Called for each item in the provided table.
-- @function on_item
-- @tparam any accumulated
-- @tparam any item

--- Called after all items have been iterated.
-- @function on_done
-- @tparam any accumulated

local on_server_idle = luanti_utils.dofile("on_server_idle.lua")

local function reduce(tbl, fn, acc, done)
    local job = {}
    local running, i = true, 1

    function job:cancel()
        running = false
    end

    local function step()
        if not running then
            return
        end
        if i > #tbl then
            if done then
                done(acc)
            end
            return
        end
        local item = tbl[i]
        i = i + 1
        on_server_idle.run(function()
            if not running then
                return
            end
            acc = fn(acc, item)
            step()
        end)
    end

    step()
    return job
end

return reduce
