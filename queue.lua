--- Simple FIFO queue implementation.
--
-- @usage
-- local max_size = 1
-- local a_queue_of_one = queue(max_size)
-- 
-- -- max_size is optional. When not defined it has no limit.
-- a_queue_of_one.push(1)
-- a_queue_of_one.size -- 1
-- a_queue_of_one.push(2) -- Throws with 'queue is empty'
-- a_queue_of_one.pop() -- 1
-- a_queue_of_one.is_empty -- true
-- a_queue_of_one.size -- 0
-- 
-- @module queue.lua
-- @tparam[opt] number max_size Maximum number of elements allowed in the queue.
-- @treturn queue Instance of a queue.
local function queue(max_size)
    local q = {}
    local head = 1
    local tail = 0
    local size = 0

    --- queue
    -- @section queue
    local M = {}

    ---
    -- @function queue.push
    -- @tparam any v Value to push
    -- @treturn boolean True when push was successful.
    function M.push(v)
        if max_size and size >= max_size then
            return false
        end

        tail = tail + 1
        q[tail] = v
        size = size + 1
        return true
    end

    ---
    -- @function queue.pop
    -- @raise Throws when queue is empty
    -- @treturn any
    function M.pop()
        if size == 0 then
            error('queue is empty')
        end

        local v = q[head]
        q[head] = nil
        head = head + 1
        size = size - 1

        if size == 0 then
            head = 1
            tail = 0
        end

        return v
    end

    ---
    -- @function queue.size
    -- @treturn integer
    function M.size()
        return size
    end

    ---
    -- @function queue.is_empty
    -- @treturn boolean
    function M.is_empty()
        return size == 0
    end

    return M
end

return queue
