local reduce = luanti_utils.dofile('async_reduce.lua')

local function map(tbl, fn, done)
    local res = {}
    return reduce(tbl, function(acc, item)
        table.insert(acc, fn(item))
        return acc
    end, res, done)
end

return map
