---
-- Checks whether a node or position is buildable to.
--
-- @module is_buildable_to.lua
--
-- @usage
-- local buildable = is_buildable_to({x=0, y=10, z=0})
-- local buildable_node = is_buildable_to({name="default:dirt_with_grass"})
--
-- @tparam NodeOrPos thing A table representing either a node (with `name`) or a position `{x, y, z}`
-- @treturn boolean True if the node is buildable_to, false if not
local function is_buildable_to(thing)
    local node = nil

    if thing.name then
        node = thing
    else -- likely a pos then
        node = core.get_node(thing)
    end

    local def = core.registered_nodes[node.name]
    return def and def.buildable_to
end

return is_buildable_to
