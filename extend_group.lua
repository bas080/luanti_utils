--- Extend callbacks for all nodes in a specific group.
--
-- Iterates over `core.registered_items` and applies `extend_item` to
-- every node belonging to the given group.
--
-- @module extend_group

--- Extend all nodes in a group.
--
-- @tparam string group_name Name of the group to target
-- @tparam table extend_def Table of callbacks to extend (see `extend_item`)
--
-- @usage
-- extend_group("leaves", {
--   after_destruct = function(next, pos, old_node)
--     minetest.remove_node(pos)
--     if next then next(pos, old_node) end
--   end
-- })
--
-- @function extend_group
local extend_item = luanti_utils.dofile("extend_item.lua")

local extend_group = function(group_name, extend_def)
  for node_name, node_def in pairs(core.registered_items) do
    local groups = node_def.groups or {}
    if groups[group_name] then
      extend_item(node_name, extend_def)
    end
  end
end

return extend_group
