local extend_function = luanti_utils.dofile('extend_function.lua')

-- Weak table to track already-migrated inventories
local migrated = setmetatable({}, { __mode = "k" })

-- Registered migration functions
local registered = {}

-- Register a migration function for an item
local function migrate_inventory(item_name, migrate_fn)
	registered[item_name] = migrate_fn
end

-- Run all registered migrations on each stack in an InventoryRef
local function do_inventory_migration(inv)
	if migrated[inv] then return end
	migrated[inv] = true

	for listname, list in pairs(inv:get_lists()) do
		for i, stack in ipairs(list) do
			local migrate_fn = registered[stack:get_name()]
			if migrate_fn then
				list[i] = migrate_fn(stack)
			end
		end
		inv:set_list(listname, list)
	end
end

core.get_meta = extend_function(core.get_meta, function(get_meta, ...) -- luacheck: ignore 122
	local meta = get_meta(...)
	local inv = meta:get_inventory()
	do_inventory_migration(inv)
	return meta
end)

-- Patch player inventories on join
core.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	do_inventory_migration(inv)
end)

return migrate_inventory
