--- Migrate world nodes
--
-- This does not perform migrations on world start but on block load.
--
-- @module migrate_node.lua
-- @usage
-- migrate_node("my_migration", {"vines:old"}, function() end)
--
-- @tparam string name A unique identifier for the migration
-- @tparam {string,...} nodenames A list of nodenames to perform the action on.
-- @tparam function action Called for each node in the nodenames list when block gets loaded.
-- @treturn nil
local function migrate_node(name, nodenames, action)
    core.register_lbm({
        name = name,
        run_at_every_load = false,
        nodenames = nodenames,
        action = action,
    })
end

return migrate_node
