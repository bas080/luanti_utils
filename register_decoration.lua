
---
-- Wraps the register decoration and makes it easier to use gennotify.
--
-- @module register_decoration.lua
--
-- @usage
-- local did = register_decoration({
--     name = "test_lake",
--     place_on = {"default:dirt_with_grass"},
--     deco_type = "simple",
--     place_nodes = {"air"},   -- we only want the position
--     fill_ratio = 1.0,
--     y_min = 0,
--     y_max = 20,
--     on_position = function(pos)
--         print("Picked lake position:", minetest.pos_to_string(pos))
--     end
-- })
--
-- @tparam DecorationDef decoration_def
-- @treturn integer decoration_id The same value returned by `core.register_decoration`.

--- DecorationDef
-- Includes all core.decoration_definition parameters and extends them.
--
-- @table DecorationDef
-- @tfield[opt] function on_position Callback called with each selected position

local _decoration_callbacks = {}
local _pending_defs = {}

local function register_decoration(def)
    assert(def.name, "Decoration must have a name")

    -- Simple fallback in case we just want positions.
    def.decoration = def.decoration or {"air"}

    -- store def for later registration
    if def.on_position then
      _pending_defs[#_pending_defs + 1] = def
    end

    -- return placeholder (def.name)
    return core.register_decoration(def)
end

core.register_on_mods_loaded(function()
    local dids = {}

    for idx, def in ipairs(_pending_defs) do
        -- register the decoration

    		local did = core.get_decoration_id(def.name)

        assert(did, "Failed to register decoration: " .. def.name)

    		dids[idx] = did

        -- store callback
        _decoration_callbacks[did] = def.on_position

        dids[#dids + 1] = did
    end

    -- now set gen_notify with the actual dids
    core.set_gen_notify("decoration", dids)
end)

core.register_on_generated(function(minp, maxp, blockseed)
    local g = core.get_mapgen_object("gennotify")
    for did, func in pairs(_decoration_callbacks) do
        local positions = g["decoration#" .. did]
        if positions then
            for _, pos in ipairs(positions) do
                func(pos)
            end
        end
    end
end)

return register_decoration
