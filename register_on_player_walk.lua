--- Global player walk callbacks
-- 
-- This module allows other modules to register callbacks that run
-- whenever a player moves from one node to another.
--
-- Example usage:
-- ```lua
-- minetest.register_on_player_walk(function(pos, prev_pos, player)
--     -- pos: current node position
--     -- prev_pos: previous node position
--     -- player: the ObjectRef of the walking player
-- end)
-- ```
--
-- Callbacks are triggered only when the player moves to a different node.
-- The module automatically tracks player positions and cleans up on leave.

local player_walk_callbacks = {}
local player_last_pos = {}

--- Registers a callback for player movement.
-- @param fn function Callback function: `fn(pos, prev_pos, player)`
--   * `pos` Table: the current node position `{x=number, y=number, z=number}`
--   * `prev_pos` Table or nil: the previous node position
--   * `player` ObjectRef: the player walking
function register_on_player_walk(fn)
    assert(type(fn) == "function", "register_on_player_walk expects a function")
    table.insert(player_walk_callbacks, fn)
end

-- Internal globalstep to track player movement
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local current = {
            x = math.floor(pos.x),
            y = math.floor(pos.y),
            z = math.floor(pos.z),
        }

        local last = player_last_pos[player]

        -- Skip if player hasn't moved to a new node
        if last and vector.equals(last, current) then
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
