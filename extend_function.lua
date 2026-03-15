--- Takes the original function and a callback that receives the old function and arguments.
-- You can decide if you want to call the old function and in which order to do operations.
-- @module extend_function
--
--
-- @tparam function original_fn The function being extended
-- @tparam function extender_fn The function that extends.
--
-- @treturn function extended_fn Takes the same arguments as original function
--
-- @usage
-- local function add (a, b)
--   a + b
-- end
-- 
-- local multiplyAWithTwoAndAdd = extend_function(add, function(og, a, b) og(a * 2, b) end)
--
local function extend_function(original_fn, extender_fn)
  --- Extender function takes the original function as first argument
  --  followed by the arguments the original function takes.
  -- @function extender_fn
  -- @treturn any Usually similar to the original_fn

  --- The wrapper that takes same args as the original fn
  --
  -- @function extended_fn
  -- @return Equal to the return of the extender_fn
  local function extended_fn(...)

    return extender_fn(original_fn, ...)
  end

  return extended_fn
end

return extend_function
