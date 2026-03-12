local function extend_function(original_fn, new_fn)
  return function(...)
    return new_fn(original_fn, ...)
  end
end

return extend_function
