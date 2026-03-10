--- Simple FIFO queue implementation.
-- Provides push/pop operations with optional maximum size.
-- @module queue

--- Create a new queue.
-- @tparam[opt] number max_size Maximum number of elements allowed in the queue.
-- @treturn table Queue instance.
local function Queue(max_size)
    local q = {}
    local head = 1
    local tail = 0
    local size = 0

    local M = {}

    --- Push a value onto the queue.
    -- @param v Value to add.
    -- @treturn boolean True if the value was added, false if the queue is full.
    function M.push(v)
        if max_size and size >= max_size then
            return false
        end

        tail = tail + 1
        q[tail] = v
        size = size + 1
        return true
    end
    
    --- Pop the next value from the queue.
    -- @treturn any The next value, or nil if the queue is empty.
    function M.pop()
        if size == 0 then
            return nil
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

    --- Get the number of elements currently in the queue.
    -- @treturn number
    function M.size()
        return size
    end

    --- Check whether the queue is empty.
    -- @treturn boolean
    function M.is_empty()
        return size == 0
    end

    return M
end

return Queue
