--- Modify texture
-- @module modify_texture.lua
--
-- @tparam string modifier String that represents the modifer part. See Luanti texture modifer docs.
-- @tparam string|{string,...} tiles Tile(s) to be modified.
--
-- @treturn string|{string,...} Tile(s) with the modifer applied.
local function modify_texture(modifier, tiles)
  if type(tiles) == "table" then
    local tbl = {}
    for i, tile in ipairs(tiles) do
      tbl[i] = modify_texture(modifier, tile)
    end
    return tbl
  end

  if type(tiles) == "string" then
    return tiles .. modifier
  end

  error("tiles must be a string or a table: " .. tostring(tiles))
end

return modify_texture
