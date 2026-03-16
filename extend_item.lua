--- Extend callbacks of a registered node by wrapping them.
-- Allows injecting behavior before/after an existing callback while still
-- optionally calling the original implementation via next.
-- This works on boths nodes and items as it uses core.override_item under the hood.
--
-- @module extend_item.lua
--
-- @see extend_function.lua
--
-- @usage
-- extend_item("default:stone", {
--   on_punch = function(next, pos, node, puncher, pointed_thing)
--     minetest.chat_send_all("Stone punched!")
--     if next then
--       return next()
--     end
--   end
-- })
--
-- @todo Find a way to document extend_def table
--
-- @tparam string node_name Name of the node in `core.registered_nodes`
-- @tparam extend_def extend_def Table of callbacks to extend
-- @treturn nil
local table_merge = luanti_utils.dofile('table_merge.lua')

local items = table_merge(core.registered_nodes, core.registered_items)

function extend_item(item_name, extend_def, items_subset)
  -- Get the original node definition
  local item_def = items_subset or items[item_name]

  local override_def = {}

  for key, extended_callback in pairs(extend_def) do
    local original_callback = item_def[key]

    override_def[key] = function(...)
      local next = nil

      -- Only define next if original callback exists
      if original_callback then
        next = function(...)
          return original_callback(...)
        end
      end

      return extended_callback(next, ...)
    end
  end

  core.override_item(item_name, override_def)
end

return extend_item

