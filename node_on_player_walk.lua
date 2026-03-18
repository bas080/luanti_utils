--- Node extension to support walk-related callbacks based on player position.
-- Remember to dofile.
--
-- @module node_on_player_walk.lua
--
-- @usage
-- luanti_utils.dofile("node_on_player_walk.lua")
-- core.register_node("mymod:walkable_node", {
--     on_player_walk_enter = function(pos, player, node) end,
--     on_player_walk_leave = function(pos, player, node) end,
-- })

--- Callbacks
-- @section callbacks

--- Called when the player walks into the current node.
-- @function on_player_walk_enter
-- @tparam ... params
-- @see params

--- Called when the player walks out of the current node.
-- @function on_player_walk_leave
-- @tparam ... params
-- @see params

--- Parameters
-- @section parameters

--- Both the enter and leave have the following function signature.
-- @function params
-- @tparam table pos Position of the node under the player.
-- @tparam core.player player The player walking over the node.
-- @tparam core.node node The node table as returned by core.get_node(pos).

local register_on_player_walk = luanti_utils.dofile("register_on_player_walk.lua")

-- TODO: Use the lighter get_node_raw
register_on_player_walk(function(pos, prev, player)
    -- Node underneath instead
    pos = vector.add(pos, { x = 0, y = -0.1, z = 0 })
    prev = vector.add(prev, { x = 0, y = -0.1, z = 0 })

    -- Leave callback
    if prev then
        local prev_node = minetest.get_node(prev)
        local prev_def = minetest.registered_nodes[prev_node.name]
        if prev_def and prev_def.on_player_walk_leave then
            prev_def.on_player_walk_leave(prev, player, prev_node)
        end
    end

    -- Enter callback
    local node = minetest.get_node(pos)
    if node and node.name then
        local node_def = minetest.registered_nodes[node.name]
        if node_def and node_def.on_player_walk_enter then
            node_def.on_player_walk_enter(pos, player, node)
        end
    end
end)
