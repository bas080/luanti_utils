--- random_vector_direction
-- Compatibility issue I ran into.
--
-- @module random_vector_direction.lua

if vector.random_direction then
  return vector.random_direction
end

local function random_vector_direction()
    -- Generate a random point on the unit sphere
    local theta = math.random() * 2 * math.pi      -- azimuthal angle
    local phi = math.acos(2 * math.random() - 1)   -- polar angle

    -- Convert spherical coordinates to Cartesian
    local x = math.sin(phi) * math.cos(theta)
    local y = math.sin(phi) * math.sin(theta)
    local z = math.cos(phi)

    return vector.new(x, y, z)
end


return vector_random_direction
