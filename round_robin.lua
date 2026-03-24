--- Round Robin
--
-- Iterate util that allows creating loops that have a low memory footprint.
-- This can replace continious loops on f.e. connected players.
-- 
-- @author bas080
--
-- @module round_robin.lua
-- 
-- @tparam function items_fn
-- @tparam function on_item
-- @treturn RoundRobin
local function round_robin(items_fn, on_item)
    assert(type(items_fn) == "function", "items_fn must be a function")
    assert(type(on_item) == "function", "on_item must be a function")

    local self = {}
    local items = {}
    local prev_items = {}
    local index = 1
    local paused = true

    local function process_next()
        if paused then return end

        if index > #items then
            prev_items = items
            items = items_fn(prev_items) or {}
            index = 1
            if #items == 0 then
                paused = true
                return
            end
        end

        local item = items[index]
        index = index + 1

        local done_called = false
        local function done()
            if done_called then return end
            done_called = true
            process_next()
        end

        on_item(item, done)
    end

    function self:start()
        paused = false
        process_next()
    end

    function self:resume()
        self:start()
    end

    function self:restart()
        paused = false
        index = 1
        prev_items = {}
        items = items_fn(prev_items) or {}
        if #items == 0 then
            paused = true
            return
        end
        process_next()
    end    

    function self:pause()
        paused = true
    end

    return self
end

return on_server_idle_round_robin
