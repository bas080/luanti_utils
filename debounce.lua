--- Returns a debounced version of a function.
-- The returned function delays execution by `delay` seconds.
-- If called again before the delay expires, the previous call is cancelled.
--
-- @module debounce
--
-- @tparam number delay Delay in seconds
-- @tparam function fn The function to debounce
-- @treturn function debounced The debounced function
local function debounce(delay, fn)
    local job = nil

    --- Wrapper of the fn that adds the debounce behavior.
    -- It forwards all arguments to `fn`.
    --
    -- @function debounced
    --
    -- @treturn job Which allows the user to cancel.
    local function debounced (...)
        local args = {...}
        if job then
            job:cancel()
        end
        job = core.after(delay, function()
            job = nil
            fn(unpack(args))
        end)

        --- The job
        --
        -- @table job
        -- @tfield function cancel Stop the debounce from completing.
        return job
    end

    return debounced

end

return debounce
