-- Only supports callbacks on the def for now.
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
