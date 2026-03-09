--- Extend callbacks of a registered node by wrapping them.
-- Allows injecting behavior before/after an existing callback while still
-- optionally calling the original implementation via `next`.
--
-- The provided callback receives `next` as its first argument. Calling `next(...)`
-- will invoke the original callback if it exists.
--
-- @module extend_item

--- Extend callbacks on a node definition.
-- Internally uses `core.override_item` to replace callbacks with wrappers.
--
-- @tparam string node_name Name of the node in `core.registered_nodes`
-- @tparam table extend_def Table of callbacks to extend
-- @tparam function extend_def.<callback> Replacement callback that receives
-- `next` as its first parameter followed by the original callback arguments.
--
-- @usage
-- extend_item("default:stone", {
--   on_punch = function(next, pos, node, puncher, pointed_thing)
--     minetest.chat_send_all("Stone punched!")
--     if next then
--       return next(pos, node, puncher, pointed_thing)
--     end
--   end
-- })
--
-- @function extend_item
local extend_item = function(node_name, extend_def)
  -- Get the original node definition
  local node_def = core.registered_nodes[node_name]

  local override_def = {}

  for key, extended_callback in pairs(extend_def) do
    local original_callback = node_def[key]

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

  core.override_item(node_name, override_def)
end

return extend_item
