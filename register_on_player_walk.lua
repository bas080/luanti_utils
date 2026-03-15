--- Global player walk callbacks
-- This module allows other modules to register callbacks that run
-- whenever a player moves from one node to another.
-- Callbacks are triggered only when the player moves to a different node.
-- The module automatically tracks player positions and cleans up on leave.
--
-- @module register_on_player_walk.lua
-- 
-- @tparam on_walk on_walk Called when a player walks.
--
-- @usage
-- register_on_player_walk(function(pos, prev_pos, player)
--     -- pos: current node position
--     -- prev_pos: previous node position
--     -- player: the ObjectRef of the walking player
-- end)

--- Callback
-- @section callback

---
-- @function on_walk
-- @tparam core.vector pos
-- @tparam core.vector prev_pos
-- @tparam core.player player

local player_walk_callbacks = {}
local player_last_pos = {}

local function register_on_player_walk(on_walk)
    table.insert(player_walk_callbacks, on_walk)
end

-- Internal globalstep to track player movement
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local current = {
            x = math.floor(pos.x + 0.5),
            y = math.floor(pos.y),
            z = math.floor(pos.z + 0.5),
        }

        local last = player_last_pos[player] or pos

        -- Skip if player hasn't moved to a new node
        if vector.equals(last, current) then
            goto continue
        end

        -- Call all registered global walk callbacks
        for _, fn in ipairs(player_walk_callbacks) do
            -- Consider cloning these to prevent player from mutating?
            -- If for performance reasons I do not do that then I should document that.
            fn(current, last, player)
        end

        player_last_pos[player] = current

        ::continue::
    end
end)

-- Cleanup player tracking on leave
minetest.register_on_leaveplayer(function(player, timed_out)
    player_last_pos[player] = nil
end)

return register_on_player_walk
