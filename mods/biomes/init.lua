print("initialized biomes")

minetest.register_alias("mapgen_stone", "nodes:stone")
minetest.register_alias("mapgen_dirt", "nodes:dirt")
minetest.register_alias("mapgen_dirt_with_grass", "nodes:grass")
minetest.register_alias("mapgen_water_source","nodes:water")
minetest.register_alias("mapgen_tree", "nodes:tree")
minetest.register_alias("mapgen_leaves", "nodes:leaves")

--the main biome
minetest.register_biome({
		name = "grass",
		node_top = "nodes:grass",
		depth_top = 1,
		node_filler = "nodes:dirt",
		depth_filler = 4,
		node_stone = "nodes:stone",
		node_riverbed = "nodes:sand",
		depth_riverbed = 2,
		y_max = upper_limit,
		y_min = -100,
		--heat_point = 92,
		--humidity_point = 16,
	}
)

--trees to decorate the land
--for tree = 0,6 do

minetest.register_decoration({
		name = "biomes:tree_deco",
		deco_type = "schematic",
		place_on = {"nodes:grass"},
		spawn_by = "air",
		--use the default game params for speed of development
		sidelen = 16,
		noise_params = {
			offset = 0.024,
			scale = 0.015,
			spread = {x = 250, y = 250, z = 250},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"grass"},
		y_max = 31000,
		y_min = 1,
		schematic = tree_schem,
		flags = "place_center_x, place_center_z",
		rotation = "random",
})

--end
