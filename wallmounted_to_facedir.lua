--- Convert wallmounted to facedir and back param2
--
-- @module wallmounted_to_facedir.lua
--
-- @usage
-- local to_facedir, to_wallmounted = luanti_utils('wallmounted_to_facedir.lua')
-- to_facedir(default_sign.param2) -- Calculate the facedir equivalent for wallmounted sign.
-- to_wallmounted(vine_param2) -- Calculate wallmounted equivalent of facedir vine.

local table_lookup = luanti_utils.dofile("table_lookup.lua")

---
-- @function to_facedir
-- @tparam integer wallmounted
-- @treturn integer facedir

---
-- @function to_wallmounted
-- @tparam integer facedir
-- @treturn integer wallmounted

local wallmounted_to_facedir = {
    [2] = 19,
    [4] = 10,
    [3] = 13,
    [5] = 4,
    [1] = 2,
    [0] = 22,
}

return table_lookup(wallmounted_to_facedir)
