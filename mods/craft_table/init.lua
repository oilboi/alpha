--this is a mod of the mineclone2 crafting table

minetest.register_node("craft_table:craft_table", {
	description = "Crafting Table",
	is_ground_content = false,
	tiles = {"crafting_workbench_top.png", "default_wood.png", "crafting_workbench_side.png",
		"crafting_workbench_side.png", "crafting_workbench_front.png", "crafting_workbench_front.png"},
	paramtype2 = "facedir",
	groups = {wood=1},
	on_rightclick = function(pos, node, player, itemstack)
		player:get_inventory():set_width("craft", 3)
		player:get_inventory():set_size("craft", 9)

		local form = "size[9,8.75]"..
		--"background[-0.19,-0.25;9.41,9.49;crafting_formspec_bg.png^crafting_inventory_workbench.png]"..
		"list[current_player;main;0,4.85;9,1;]" ..
	  "list[current_player;main;0,6.08;9,3;9]" ..
		"list[current_player;craft;1.75,0.5;3,3;]"..
		"list[current_player;craftpreview;6.1,1.5;1,1;]"..
		"listring[current_player;main]"..
		"listring[current_player;craft]"

		minetest.show_formspec(player:get_player_name(), "main", form)
	end,
	sounds = sounds.wood(),
})
