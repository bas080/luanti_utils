--- Helper to register nodes with extra features
-- @module register_node_copy

local table_merge = luanti_utils.dofile('table_merge.lua')

--- Register a node like `core.register_node` but with additional features.
-- Prevents mutation of the original definition and supports `copy_of`.
--
-- @tparam string node_name The name of the node to register.
-- @tparam table def Table containing node properties, may include `copy_of`.
-- @raise Error if `copy_of` references a non-existent node.
-- @usage
-- local register_node_copy = require("register_node")
-- register_node("mymod:leaf", "copy:node", function(copy) return {
--     description = "Leaf",
--     tiles = {"leaf.png"},
--     copy_of = "default:leaves"
-- })
local function register_node_copy(node_name, copied_node_name, def_fn)
    -- Make a deep copy to prevent external mutation
    local parent = table.copy(core.registered_items[copied_node_name])
    local def = table_merge(parent, def_fn(parent))

    core.register_node(node_name, def)
end

return register_node_copy
