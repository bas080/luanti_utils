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
