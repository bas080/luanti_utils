--- Ensure a node is loaded and call a callback with it.
--
-- This function attempts to get the node at `pos`. If the node is not
-- loaded yet, it requests the server to emerge the area containing `pos`.
-- Once the node becomes available, the provided callback is called with
-- the node and its position.
--
-- The callback is always called asynchronously if the node needs to be
-- emerged. Otherwise, it may be called immediately.
--
--
-- @module emerge_node

--- Retrieve a node at a given position and call a callback when available.
--
-- @tparam table pos Table with `x`, `y`, `z` coordinates of the node
-- @tparam function cb Function that receives `(node, pos)` once available
-- @raise error If `pos` is not a table or `cb` is not a function
--
-- @usage
-- emerge_node({x=0, y=10, z=0}, function(node, pos)
--     print("Node at", pos.x, pos.y, pos.z, "is", node.name)
-- end)
local when_idle = luanti_utils.dofile('run_when_idle.lua')

local function emerge_node(pos, cb)
    local existing = minetest.get_node_or_nil(pos)

    if not existing then
        when_idle.run(function()
            core.emerge_area(pos, pos, function(blockpos, action, calls_remaining, param)
                if calls_remaining == 0 then
                    cb(minetest.get_node(pos), pos)
                end
            end)
        end)
        return
    end
    cb(existing, pos)
end

return emerge_node
