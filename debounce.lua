--- Create a debounced version of a function.
--
-- The returned function delays calling `fn` until `delay` seconds have
-- passed without any new calls. If the function is called again before
-- the delay expires, the timer resets. Only the **last call** executes.
--
-- @tparam number delay Time in seconds to wait after the last call.
-- @tparam function fn The function to debounce.
-- @treturn function Debounced version of `fn`.
--
-- @usage
-- local update = debounce(2, function(player)
--     print("Updating for", player:get_player_name())
-- end)
-- update(player) -- will run 2 seconds after the last call
local function debounce(delay, fn)
    local job = nil

    return function(...)
        local args = {...}
        if job then
            job:cancel()
        end
        job = core.after(delay, function()
            job = nil
            fn(unpack(args))
        end)
    end
end

return debounce
