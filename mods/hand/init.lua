--create advanced time tables
digging_times = {}


-- The hand
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1,y=1,z=2.5},
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level = 0,
		groupcaps = {
			stone = {times={[1]=1}, uses=0, maxlevel=100},
      dirt = {times={[1]=1}, uses=0, maxlevel=100},
			wood = {times={[1]=1}, uses=0, maxlevel=100},
		},
		damage_groups = {fleshy=1},
	}
})


--then we rewrite the hand using Wuzzy's hand mod
local def = minetest.registered_items[""]
minetest.register_node("hand:hand", {
	description = "",
	tiles = {"character.png"},
	inventory_image = "blank.png",
	visual_scale = 1,
	wield_scale = {x=1,y=1,z=1},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "mcl_meshhand.b3d",
	node_placement_prediction = "",
	range = def.range,
})

--run Wuzzy's initialization mod in the same instance as the replacement
minetest.register_on_joinplayer(function(player)
		player:get_inventory():set_size("hand", 1)
	  player:get_inventory():set_stack("hand", 1, "hand:hand")
end)
