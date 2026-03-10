local reduce = luanti_utils.dofile('async_reduce.lua')

local function each(tbl, fn, done)
    return reduce(tbl, function(_, item)
        fn(item)
        return nil  -- accumulator unused
    end, nil, done)
end

return each

