local command = {
	description = "List\'s the items of a player\'s inventory",
	params = "'<player> [listname]' or '<player> --list' to list all inventories",
	privs = { getinv = true }
}

--- Returns a list of items in a player's inventory
--- @param name string The name of the player who executed the command
--- @param param any The parameters of the command
function command.func(name, param)
	local pname, ilist = param:match("^(%S+) (.+)$")
	if not (pname and ilist) then
		pname = param
		ilist = "main"
	end
	local out = ""
	local inv = core.get_inventory({ type = "player", name = pname })
	if not inv then return false, "No Player" end
	if ilist == "--list" then
		local lists = inv:get_lists()
		if not lists then return false, "Error getting inventories list" end
		local ilists = {}
		for listname, _ in pairs(lists) do
			ilists[#ilists + 1] = listname .. "(" .. inv:get_size(listname) .. ")"
		end
		out = table.concat(ilists, ", ")
		return true, "Inventories of " .. pname .. ": " .. out
	end
	local list = inv:get_list(ilist)
	local isempty = inv:is_empty(ilist)
	if not list or isempty == true then return false, "List not exists or empty" end
	local items = {}
	for _, stack in ipairs(list) do
		local descr = stack:get_short_description()
		local count = stack:get_count()
		if descr and descr ~= "" then
			if count and count > 1 then
				descr = descr .. "(" .. count .. ")"
			end
			table.insert(items, descr)
		end
	end
	out = table.concat(items, ", ")
	return true, "Inventory '" .. ilist .. "' of " .. pname .. ": " .. out
end

core.register_privilege("getinv", "Allows usage of the /getinv command")
core.register_chatcommand("getinv", command)
