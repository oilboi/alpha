
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
	inventory_image = "iron.png",
	groups = {iron = 1},
})
minetest.register_craftitem("items:gold", {
	description = "Gold Ingot",
	inventory_image = "gold.png",
	groups = {gold = 1},
})
minetest.register_craftitem("items:diamond", {
	description = "Diamond",
	inventory_image = "diamond.png",
	groups = {gold = 1},
})
minetest.register_craftitem("items:paper", {
	description = "Paper",
	inventory_image = "default_paper.png",
	groups = {paper = 1},
})
minetest.register_craftitem("items:bone", {
	description = "Bone",
	inventory_image = "bone.png",
	groups = {bone = 1},
})

minetest.register_craftitem("items:apple", {
	description = "Apple",
	inventory_image = "default_apple.png",
	groups = {food = 1,leafdecay_drop=1},
	food = 1,
	range = 0,
})
minetest.register_craftitem("items:porkchop", {
	description = "Porkchop",
	inventory_image = "porkchop.png",
	groups = {food = 1,leafdecay_drop=1},
	food = 2,
	range = 0,
})

minetest.register_craftitem("items:wheat", {
	description = "Wheat",
	inventory_image = "wheat.png",
	groups = {food = 1, flammable = 2},
})

minetest.register_craftitem("items:bread", {
	description = "Bread",
	inventory_image = "farming_bread.png",
	groups = {food = 1,leafdecay_drop=1},
	food = 4,
	range = 0,
})

minetest.register_craftitem("items:arrow", {
	description = "Arrow",
	inventory_image = "arrow_inv.png",
	groups = {arrow = 1},
})

minetest.register_craftitem("items:string", {
	description = "String",
	inventory_image = "string.png",
	groups = {string = 1},
})

minetest.register_craftitem("items:spider_eye", {
	description = "Spider Eye",
	inventory_image = "spider_eye.png",
	groups = {food = 1},
	food = -2,
	range = 0,
})
