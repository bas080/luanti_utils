--- Persistent FIFO queue backed by Luanti ModStorage.
-- Queue contents must be serializable with core.serialize.
-- @module persistent_queue

local storage = core.get_mod_storage()

--- Create a new persistent queue.
-- @tparam string key Storage key used to persist the queue.
-- @tparam[opt] number max_size Maximum queue size.
-- @treturn table Queue instance.
local function Queue(key, max_size)
    local data = storage:get_string(key)

    local state
    if data ~= "" then
        state = core.deserialize(data)
    end

    if not state then
        state = {
            q = {},
            head = 1,
            tail = 0,
            size = 0
        }
    end

    local q = state.q
    local head = state.head
    local tail = state.tail
    local size = state.size

    local M = {}

    local function persist()
        state.q = q
        state.head = head
        state.tail = tail
        state.size = size
        storage:set_string(key, core.serialize(state))
    end

    --- Push a value onto the queue.
    -- @param v Serializable value.
    -- @treturn boolean True if inserted, false if queue full.
    function M.push(v)
        if max_size and size >= max_size then
            return false
        end

        tail = tail + 1
        q[tail] = v
        size = size + 1

        persist()
        return true
    end

    --- Pop the next value from the queue.
    -- @treturn any Value or nil if empty.
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

        persist()
        return v
    end

    --- Get queue size.
    -- @treturn number
    function M.size()
        return size
    end

    --- Check if queue is empty.
    -- @treturn boolean
    function M.is_empty()
        return size == 0
    end

    return M
end

return Queue