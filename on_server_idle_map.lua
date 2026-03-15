--- Map over a table in small increments during server idle frames.
--
-- `on_server_idle_reduce.lua`
-- 
-- This avoids blocking the server for too long when transforming large tables.
--
-- @module on_server_idle_map.lua

local reduce = luanti_utils.dofile('on_server_idle_reduce.lua')

--- Map each value in `tbl` through `fn`.
--
-- @tparam table tbl Table to map.
-- @tparam function fn Function applied to each item.
-- @tparam[opt] function done Optional callback called with the resulting table.
-- @treturn table Job object with a `cancel()` method.
local function map(tbl, fn, done)
    local res = {}
    return reduce(tbl, function(acc, item)
        table.insert(acc, fn(item))
        return acc
    end, res, done)
end

return map
