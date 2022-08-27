core.register_privilege("getinv","Allows use /getinv command")
core.register_chatcommand("getinv", {
  description = "List items of player's inventory",
  params = "'<player> [listname]' or '<player> -list' to list all inventories",
  privs = {getinv=true},
  func = function(name,param)
    local pname, ilist = param:match("^(%S+) (.+)$")
    if not (pname and ilist) then
      pname = param
      ilist = "main"
    end
    local out = ""
    local inv = core.get_inventory({type="player",name=pname})
    if not inv then return false, "No Player" end
    if ilist == "-list" then
      local lists = inv:get_lists()
      if not lists then return false, "Error getting inventories list" end
      for listname,_ in pairs(lists) do
        out = out..listname.."("..inv:get_size(listname).."), "
      end
      return true, "Inventories of "..pname..": "..out
    end
    local list = inv:get_list(ilist)
    if not list then return false, "List not exists" end
    for _,stack in ipairs(list) do
      local descr = stack:get_description()
      if descr and descr ~= "" then
        out = out..descr..", "
      end
    end
    return true, "Inventory '"..ilist.."' of "..pname..": "..out
end})
