--- Iterate over a table in small increments during server idle frames.
--
-- This allows processing large tables without causing large frame-time spikes.
--
-- @module on_server_idle_each

local reduce = luanti_utils.dofile('async_reduce.lua')

--- Iterate over each item in a table.
--
-- @tparam table tbl Table to iterate over.
-- @tparam function fn Callback called for each item: `fn(item)`.
-- @tparam[opt] function done Optional callback called when iteration finishes.
-- @treturn table Job object with a `cancel()` method.
local function each(tbl, fn, done)
    return reduce(tbl, function(_, item)
        fn(item)
        return nil  -- accumulator unused
    end, nil, done)
end

return each

