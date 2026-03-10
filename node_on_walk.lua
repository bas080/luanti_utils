--- Node extension to support walk-related callbacks based on player position.
--
-- Nodes can define:
-- * `on_walk_enter(pos, player, node)` – called when a player enters a new node position
-- * `on_walk_leave(pos, player, node)` – called when a player leaves a previous node position
--
-- Example usage:
-- core.register_node("mymod:walkable_node", {
--     on_walk_enter = function(pos, player, node) end,
--     on_walk_leave = function(pos, player, node) end,
-- })
--
-- Callback parameters:
-- @param pos Table: position of the node under the player.
-- @param player ObjectRef: the player walking over the node.
-- @param node Table: the node table as returned by minetest.get_node(pos).

local register_on_player_walk = luanti_utils.dofile('register_on_player_walk.lua')

register_on_player_walk(function(pos, prev, player)
    -- Node underneath instead
    pos = vector.add(pos, {x=0,y=-1,z=0})
    prev = vector.add(pos, {x=0,y=-1,z=0})

    -- Leave callback
    if prev then
        local prev_node = minetest.get_node(prev)
        local prev_def = minetest.registered_nodes[prev_node.name]
        if prev_def and prev_def.on_walk_leave then
            prev_def.on_walk_leave(prev, player, prev_node)
        end
    end

    -- Enter callback
    local node = minetest.get_node(pos)
    if node and node.name then
        local node_def = minetest.registered_nodes[node.name]
        if node_def and node_def.on_walk_enter then
            node_def.on_walk_enter(pos, player, node)
        end
    end
end)
