--drop items when killed or die
minetest.register_on_dieplayer(function(player)
  local inv = player:get_inventory()
  local list_table = inv:get_lists()
  --go through lists
  for list_name in pairs(list_table) do
    if list_name == "main" or list_name == "craft" then
      local list = inv:get_list(list_name)
      --go through table within lists
      for i,g in pairs(list) do
        --remove from inventory and drop the item
        local item = inv:get_stack(list_name, i):get_name()
        local pos = player:getpos()
        pos.y = pos.y + 1
        --add as many items as in the stack
        for i = 1,inv:get_stack(list_name, i):get_count() do
          local object = minetest.add_item(pos,item)
  				object:set_velocity({x=math.random(-7,7)*math.random(), y=math.random(5,7)*math.random(), z=math.random(-7,7)*math.random()})
        end
        --remove the item from inventory
        inv:set_stack(list_name, i, "")
      end
    end
  end
end)