--- Filter a table in small increments during server idle frames.
--
-- This avoids blocking the server for too long when selecting subsets of large tables.
--
-- @module on_server_idle_filter.lua

local reduce = luanti_utils.dofile('on_server_idle_reduce.lua')

--- Filter items in `tbl` using `predicate`.
--
-- @tparam table tbl Table to filter.
-- @tparam function predicate Function called for each item: `predicate(item)`.
--   If it returns truthy, the item is kept.
-- @tparam[opt] function done Optional callback called with the filtered table.
-- @treturn table Job object with a `cancel()` method.
local function filter(tbl, predicate, done)
    local res = {}
    return reduce(tbl, function(acc, item)
        if predicate(item) then
            table.insert(acc, item)
        end
        return acc
    end, res, done)
end

return filter
