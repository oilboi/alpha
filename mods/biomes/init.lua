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
		y_max = 31000,
		y_min = 1,
		heat_point = 50,
		humidity_point = 35,
	}
)

--the desert biome
minetest.register_biome({
		name = "desert",
		node_top = "nodes:sand",
		depth_top = 1,
		node_filler = "nodes:sand",
		depth_filler = 4,
		node_stone = "nodes:stone",
		node_riverbed = "nodes:sand",
		depth_riverbed = 2,
		y_max = 31000,
		y_min = 1,
		heat_point = 92,
		humidity_point = 16,
	}
)

--the underwater biome
minetest.register_biome({
		name = "underwater",
		node_top = "nodes:sand",
		depth_top = 1,
		node_filler = "nodes:sand",
		depth_filler = 4,
		node_stone = "nodes:stone",
		node_riverbed = "nodes:dirt",
		depth_riverbed = 2,
		y_max = 1,
		y_min = -300,
		--heat_point = 92,
		--humidity_point = 16,
	}
)

--trees to decorate the land
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

-- cactus in deserts
minetest.register_decoration({
	deco_type = "simple",
	place_on = "nodes:sand",
	sidelen = 16,
	fill_ratio = 0.001,
	biomes = {"desert"},
	decoration = "nodes:cactus",
	height = 3,
	height_max = 6,
	y_min = 1,
	y_max = 31000,
})


-- sugar cane that spawns next to water
minetest.register_decoration({
	deco_type = "simple",
	place_on = "nodes:grass",
	sidelen = 16,
	fill_ratio = 0.1,
	biomes = {"grass"},
	decoration = "nodes:sugarcane",
	height = 3,
	height_max = 6,
	y_min = 1,
	y_max = 1,
	spawn_by = "nodes:water",
	num_spawn_by = 1,
})


-- tall grass
minetest.register_decoration({
	deco_type = "simple",
	place_on = "nodes:grass",
	sidelen = 16,
	fill_ratio = 0.9,
	biomes = {"grass"},
	decoration = "nodes:tall_grass",
	height = 1,
	y_min = 1,
	y_max = 5000,
})

--ores

--coal
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:coal",
	wherein        = "nodes:stone",
	clust_scarcity = 8 * 8 * 4,
	clust_num_ores = 8,
	clust_size     = 3,
	y_max          = 64,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "default:stone_with_coal",
	wherein        = "default:stone",
	clust_scarcity = 24 * 24 * 4,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = 0,
	y_min          = -31000,
})

-- Iron

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:iron",
	wherein        = "nodes:stone",
	clust_scarcity = 9 * 9 * 3,
	clust_num_ores = 12,
	clust_size     = 3,
	y_max          = 31000,
	y_min          = -3100,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:iron",
	wherein        = "nodes:stone",
	clust_scarcity = 7 * 7 * 2,
	clust_num_ores = 5,
	clust_size     = 3,
	y_max          = 0,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:iron",
	wherein        = "nodes:stone",
	clust_scarcity = 24 * 24 * 4,
	clust_num_ores = 27,
	clust_size     = 6,
	y_max          = -64,
	y_min          = -31000,
})

-- Gold

minetest.register_ore({
ore_type       = "scatter",
ore            = "nodes:gold",
wherein        = "nodes:stone",
clust_scarcity = 13 * 13 * 2,
clust_num_ores = 5,
clust_size     = 3,
y_max          = -32,
y_min          = -3100,
})

minetest.register_ore({
ore_type       = "scatter",
ore            = "nodes:gold",
wherein        = "nodes:stone",
clust_scarcity = 15 * 15 * 2,
clust_num_ores = 3,
clust_size     = 2,
y_max          = -32,
y_min          = -3100,
})

minetest.register_ore({
ore_type       = "scatter",
ore            = "nodes:gold",
wherein        = "nodes:stone",
clust_scarcity = 13 * 13 * 2,
clust_num_ores = 5,
clust_size     = 3,
y_max          = -32,
y_min          = -31000,
})

-- Diamond

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:diamond",
	wherein        = "nodes:stone",
	clust_scarcity = 15 * 15 * 2,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -64,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:diamond",
	wherein        = "nodes:stone",
	clust_scarcity = 17 * 17 * 2,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -64,
	y_min          = -31000,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nodes:diamond",
	wherein        = "nodes:stone",
	clust_scarcity = 15 * 15 * 2,
	clust_num_ores = 4,
	clust_size     = 3,
	y_max          = -64,
	y_min          = -31000,
})
