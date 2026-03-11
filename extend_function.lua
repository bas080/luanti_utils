local function extend_function(original_fn, new_fn)
  return function(...)
    new_fn(original_fn, ...)
  end
end

return extend_function
