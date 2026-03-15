--- Extend callbacks for all nodes in a specific group.
--
-- Iterates over items and applies `extend_item` to
-- every node belonging to the given group.
-- 
-- Uses [core.override](https://github.com/luanti-org/luanti/blob/5932c174022a0cd1c4a1f8c657694fea2fce5161/doc/lua_api.md?plain=1#L6106).
--
-- @module extend_group.lua
--
-- @see extend_item.lua
--
-- @usage
-- extend_group("leaves", {
--   after_destruct = function(next, pos, old_node)
--     minetest.remove_node(pos)
-- 
--     if next then next() end
--   end
-- })
--
-- -- To make sure it only targets nodes you do the following.
--
-- extend_group("leaves", function() end, core.registered_nodes)
-- 
-- 
-- @tparam string group_name Name of the group to target
-- @tparam table extend_def Table of callbacks to extend (see `extend_item`)
-- @tparam[opt] {string,...} items If you want to work on a subset of items/nodes.
--
-- @todo Consider allowing overwrite of underlying functions by passing stuff to next.
local extend_item = luanti_utils.dofile("extend_item.lua")

local function extend_group (group_name, extend_def, items)
  for node_name, node_def in pairs(core.registered_items) do
    local groups = node_def.groups or {}
    if groups[group_name] then
      extend_item(node_name, extend_def, items)
    end
  end
end

return extend_group
