--set a cool inventory
minetest.register_on_joinplayer(function(player)
	--init inventory
  player:get_inventory():set_width("craft", 2)
	player:get_inventory():set_size("craft", 4)
	player:get_inventory():set_width("main", 9)
	player:get_inventory():set_size("main", 36)


	--set hotbar size
	player:hud_set_hotbar_itemcount(9)

  --gui formspec
  local form = "size[9,8.75]"..
  --texture
  "background[-0.19,-0.25;9.41,9.49;crafting_formspec_bg.png]"..
  -- main gui
  "list[current_player;main;0,4.5;9,3;9]"..
  "list[current_player;main;0,7.74;9,1;]"..
  --craft gui
  "list[current_player;craft;4,1;2,2]"..
  "list[current_player;craftpreview;7,1.5;1,1;]"

  --set the formspec
  player:set_inventory_formspec(form)


  --add hotbar images
	player:hud_set_hotbar_image("gui_hotbar.png")
	player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")

end)
