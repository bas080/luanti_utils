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
-- @param pos Table: position of the node under the player (floored).
-- @param player ObjectRef: the player walking over the node.
-- @param node Table: the node table as returned by minetest.get_node(pos).

local player_last_pos = {}

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local floored = {
            x = math.floor(pos.x),
            y = math.floor(pos.y - 0.5),
            z = math.floor(pos.z),
        }

        local last = player_last_pos[player]

        -- Skip if player hasn't moved to a new floored node
        if last and vector.equals(last, floored) then
            goto continue
        end

        -- Leave callback
        if last then
            local last_node = minetest.get_node(last)
            if last_node and last_node.name then
                local last_def = minetest.registered_nodes[last_node.name]
                if last_def and last_def.on_walk_leave then
                    last_def.on_walk_leave(last, player, last_node)
                end
            end
        end

        -- Enter callback
        local node = minetest.get_node(floored)
        if node and node.name then
            local node_def = minetest.registered_nodes[node.name]
            if node_def and node_def.on_walk_enter then
                node_def.on_walk_enter(floored, player, node)
            end
        end

        player_last_pos[player] = floored

        ::continue::
    end
end)

minetest.register_on_leaveplayer(function(player, timed_out)
    local last = player_last_pos[player]
    if last then
        local last_node = minetest.get_node(last)
        if last_node and last_node.name then
            local last_def = minetest.registered_nodes[last_node.name]
            if last_def and last_def.on_walk_leave then
                last_def.on_walk_leave(last, player, last_node)
            end
        end
        player_last_pos[player] = nil
    end
end)
