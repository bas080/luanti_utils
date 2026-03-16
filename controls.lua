---
-- This module simply returns the controls mod as is.
-- 
-- [https://content.luanti.org/packages/mt-mods/controls/](https://content.luanti.org/packages/mt-mods/controls/)
--
-- @module controls.lua
--
-- @usage
-- local controls = luanti_utils.dofile('controls.lua')
-- 
-- controls.register_on_press(function(player, key)
--     -- Called when a key is pressed
--     -- player: player object
--     -- key: key pressed
-- end)
--
-- controls.register_on_hold(function(player, key, length)
--     -- Called every globalstep while a key is held
--     -- player: player object
--     -- key: key pressed
--     -- length: length of time key has been held in seconds
-- end)
--
-- controls.register_on_release(function(player, key, length)
--     -- Called when a key is released
--     -- player: player object
--     -- key: key pressed
--     -- length: length of time key was held in seconds
-- end)


if not minetest.get_modpath("controls") then
    error("controls mod is required but not found")
end

--- Module table
-- @table controls
-- @tfield controls.register_on_press register_on_press
-- @tfield controls.register_on_hold register_on_hold
-- @tfield controls.register_on_release register_on_release

---
-- @function controls.register_on_press
-- @tparam core.player player
-- @tparam string key
 
---
-- @function controls.register_on_hold
-- @tparam core.player player
-- @tparam string key
-- @tparam integer length 

---
-- @function controls.register_on_release
-- @tparam core.player player
-- @tparam string key
-- @tparam integer length 

return controls
