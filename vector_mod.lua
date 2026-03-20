
local function vector_mod(v, m)
  return vector.new(
    v.x % m,
    v.y % m,
    v.z % m
  )
end

return vector_mod
