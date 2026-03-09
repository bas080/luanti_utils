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
