---
-- Predicate to check if a node name is part of a group or matches a name exactly.
--
-- @module node_matches.lua
--
-- @tparam string nodename
-- @tparam string[] nodenames
--
-- @treturn boolean
local function node_matches(nodename, nodenames)
	for _, pat in ipairs(nodenames) do
		if pat:sub(1, 6) == "group:" then
			local group = pat:sub(7)
			if core.get_item_group(nodename, group) > 0 then
				return true
			end
		elseif nodename == pat then
			return true
		end
	end
	return false
end

return node_matches
