--- Re-use existing node definitions and build ontop of them.
-- The return value is merged into a copy of the node definition before registering.
-- @module register_node_copy.lua
--
-- @tparam string node_name Name of the new node.
-- @tparam string copied_node_name The name of the node to copy.
-- @tparam define define_fn Callback with arg being the node def that is being copied.
-- @treturn nil
-- 
-- @usage
-- local register_node_copy = require("register_node")
-- register_node("mymod:leaves", "default:leaves", function(default_leaves) return {
--     -- Overwrite certain values.
--     description = "Leaf",
--     tiles = {"mymod_leaves.png"},
-- })

--- Callbacks
-- @section Callbacks

---
-- @function define
-- @tparam core.node_definition copied_node_def

local table_merge = luanti_utils.dofile('table_merge.lua')

local function register_node_copy(node_name, copied_node_name, def_fn)
    -- Make a deep copy to prevent external mutation
    local parent = table.copy(core.registered_items[copied_node_name])
    local def = table_merge(parent, def_fn(parent))

    core.register_node(node_name, def)
end

return register_node_copy
