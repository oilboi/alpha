
minetest.register_craftitem("items:stick", {
	description = "Stick",
	inventory_image = "default_stick.png",
	groups = {stick = 1, flammable = 1},
})

minetest.register_craftitem("items:coal", {
	description = "Coal",
	inventory_image = "coal.png",
	groups = {coal = 1, flammable = 2},
})

minetest.register_craftitem("items:iron", {
	description = "Iron Ingot",
	inventory_image = "iron_ingot.png",
	groups = {iron = 1},
})
