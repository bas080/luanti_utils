--- Get values by key or value.
-- @module table_lookup.lua
--
-- @usage
-- local by_key, by_value = table_lookup({
--   "red" = "wool:red",
--   "blue" = "wool:blue",
-- })
--
-- by_key("red") -- "wool:red"
-- by_value("wool:blue") -- "blue"
-- @raise When a value has multiple keys.
--
-- @tparam table tbl
--
-- @treturn function by_key
-- @treturn function by_value
local function table_lookup(tbl)
    local reverse = {}

    for k, v in pairs(tbl) do
        if reverse[v] ~= nil then
            error(("duplicate value '%s' for keys '%s' and '%s'"):format(v, reverse[v], k))
        end

        reverse[v] = k
    end

    --- Lookup value by key
    -- @function by_key
    -- @tparam any key
    -- @treturn any
    local function by_key(key)
        return tbl[key]
    end

    --- Lookup key by value
    -- @function by_value
    -- @tparam any value
    -- @treturn any
    local function by_value(value)
        return reverse[value]
    end

    return by_key, by_value
end

return table_lookup
