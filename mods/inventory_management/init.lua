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
        local wear = inv:get_stack(list_name, i):get_wear()
        local pos = player:getpos()
        pos.y = pos.y + 1.5
        --add as many items as in the stack
        for i = 1,inv:get_stack(list_name, i):get_count() do
          local object = minetest.add_item(pos,item.." 1 "..wear)
  				object:set_velocity({x=math.random(-7,7)*math.random(), y=math.random(5,7)*math.random(), z=math.random(-7,7)*math.random()})
        end
        --remove the item from inventory
        inv:set_stack(list_name, i, "")
      end
    end
  end
end)


--drop items from the craft inventory when they close it
minetest.register_on_player_receive_fields(function(player, formname, fields)
  if fields.quit == "true" then
    local inv = player:get_inventory()
    local list = inv:get_list("craft")
    --check if empty
    if inv:is_empty("craft") == false then
      --get list table
      local list = inv:get_list("craft")
      --go through table within lists
      for i,g in pairs(list) do
        --remove from inventory and drop the item
        local item = inv:get_stack("craft", i):get_name()
        local wear = inv:get_stack("craft", i):get_wear()
        local pos = player:getpos()
        pos.y = pos.y + 1.5
        local look = player:get_look_dir()
        --add as many items as in the stack
        for i = 1,inv:get_stack("craft", i):get_count() do
          local object = minetest.add_item(pos,item.." 1 "..wear)
          object:set_velocity({x=(look.x*math.random(1,2))+(math.random()*math.random(-1,1)), y=((look.y*math.random(3,5))*math.random())+math.random(1,2), z=(look.z*math.random(1,2))+(math.random()*math.random(-1,1))})
        end
        --remove the item from inventory
        inv:set_stack("craft", i, "")
      end
    end
  end
end)
