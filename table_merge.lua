--- Merges two tables without mutating them
--
-- @module table_merge.lua
--
-- @usage
-- table_merge({a = 1, b = 3}, {b = 2, c = 3}) -- {a = 1, b = 2, c = 3}
-- @tparam table t1 The table whos properties are overwritten.
-- @tparam table t2 The table that is replayed onto the overwritten table.
--
-- @treturn table
local function table_merge(t1, t2)
    local tbl = table.copy(t1)

    for k, v in pairs(t2) do
        tbl[k] = v
    end

    return tbl
end

return table_merge
