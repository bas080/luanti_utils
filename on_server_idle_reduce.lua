local on_idle = luanti_utils.dofile('on_idle.lua')

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
