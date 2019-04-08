--drop items when killed or die
minetest.register_on_dieplayer(function(player)
  print(player:get_player_name().." is ded")
  local inv = player:get_inventory()
  local lists = inv:get_lists()
  for l = 1,table.getn(lists) do
    for i = 1,table.getn(lists[l]) do
      print("lists[l]")

    end
  end
end)
