--- More efficient loops over random set of items.
-- Will NOT contain duplicate picks.
--
-- @module random_each.lua
--
-- @tparam table items List of items to randonly pick from.
-- @tparam function on_item Called for each randomly picked item.
-- @tparam[opt] number ratio The ratio of items to pick.
--
-- @usage
-- local items = {1,2,3}
--
-- -- Randomly pick half of the items in the table rounded down.
-- random_each(items, on_item, 0.5)

local table_shallow_copy = luanti_utils.dofile("table_shallow_copy.lua")

local function random_each(items, on_item, ratio)
	ratio = ratio or 1
	items = table_shallow_copy(items)
	local n = math.min(math.floor(ratio * #items), #items)

	for i = 1, n do
		local j = math.random(i, #items)
		items[i], items[j] = items[j], items[i] -- swap
		on_item(items[i]) -- yield this item
	end
end

return random_each
