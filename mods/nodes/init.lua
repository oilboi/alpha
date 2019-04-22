print("initialized nodes")

--this is all self explanitory

minetest.register_node("nodes:stone",
{
  description = "Stone",
  tiles = {"default_stone.png"},
  groups = {stone = 1},
  sounds = sounds.stone(),
  drop = "nodes:cobble",
}
)
minetest.register_node("nodes:cobble",
{
  description = "Cobblestone",
  tiles = {"default_cobble.png"},
  groups = {stone = 1},
  sounds = sounds.stone(),
}
)

local groups = {"coal","iron","gold","diamond"}
local drops = {"items:coal","nodes:iron","nodes:gold","items:diamond"}
local levels = {1,2,3,4}

for i = 1,table.getn(groups) do
  minetest.register_node("nodes:"..groups[i],
  {
    description = groups[i],
    tiles = {groups[i].."_ore.png"},
    groups = {stone = levels[i]},
    drop = drops[i],
    sounds = sounds.stone(),
  }
  )
end

minetest.register_node("nodes:dirt",
{
  description = "Dirt",
  tiles = {"default_dirt.png"},
  groups = {dirt = 1},
  sounds = sounds.dirt(),
}
)

minetest.register_node("nodes:grass",
{
  description = "Grass",
  tiles = {"default_grass.png","default_dirt.png","default_grass.png"},
  groups = {dirt = 1},
  sounds = sounds.dirt(),
}
)

minetest.register_node("nodes:sand",
{
  description = "Sand",
  tiles = {"default_sand.png"},
  groups = {dirt = 1},
  sounds = sounds.stone(),
}
)
minetest.register_node("nodes:sugarcane", {
	description = "Sugar Cane",
	tiles = {"sugarcane.png"},
  drawtype = "plantlike",
  paramtype = "light",
  sunlight_propagates = true,
	groups = {flammable=1,attached_node=1,instant=1,leaves=1},
	sounds = sounds.leaves(),
  walkable = false,
  selection_box = {
		type = "fixed",
		fixed = {
				{-0.35, -0.5, -0.35, 0.35, 0.5, 0.35},
			},
		},
})

local water_viscocity = 1
minetest.register_node("nodes:water",
{
  description = "Water",
  drawtype = "liquid",
  waving = 3,
  alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
  liquid_viscosity = water_viscocity,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
  tiles = {
		{
			name = "water_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
		{
			name = "water_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
  groups = {water = 1,liquid=1,source = 1},
  liquidtype = "source",
  liquid_alternative_flowing = "nodes:water_flowing",
  liquid_alternative_source = "nodes:water",
  sounds = sounds.water(),
}
)
minetest.register_node("nodes:water_flowing",
{
  description = "Water",
  drawtype = "flowingliquid",
  waving = 3,
  alpha = 160,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
  liquid_viscosity = water_viscocity,
  paramtype2 = "flowingliquid",
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
  tiles = {"water.png"},
	special_tiles = {
		{
			name = "water_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "water_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
  groups = {water = 1,liquid=1,flowing=1},
  liquidtype = "flowing",
  liquid_alternative_flowing = "nodes:water_flowing",
  liquid_alternative_source = "nodes:water",
  sounds = sounds.water(),
}
)

minetest.register_node("nodes:lava", {
	description = "Lava",
	drawtype = "liquid",
	tiles = {
		{
			name = "default_lava_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
		{
			name = "default_lava_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.0,
			},
		},
	},
	paramtype = "light",
	light_source = 14,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "nodes:lava_flowing",
	liquid_alternative_source = "nodes:lava",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 1, liquid = 1,source = 1},
})

minetest.register_node("nodes:lava_flowing", {
	description = "Flowing Lava",
	drawtype = "flowingliquid",
	tiles = {"default_lava.png"},
	special_tiles = {
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
		{
			name = "default_lava_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 3.3,
			},
		},
	},
	paramtype = "light",
	paramtype2 = "flowingliquid",
	light_source = 14,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "nodes:lava_flowing",
	liquid_alternative_source = "nodes:lava",
	liquid_viscosity = 7,
	liquid_renewable = false,
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {lava = 3, liquid = 1, flowing=1},
})

minetest.register_node("nodes:wood", {
	description = "Wood",
	tiles = {"default_wood.png"},
	groups = {wood = 1,flammable=1},
	sounds = sounds.wood(),
})

minetest.register_node("nodes:tree", {
	description = "Tree",
	tiles = {"default_tree_top.png", "default_tree_top.png","default_tree.png"},
	is_ground_content = false,
  after_destruct = function(pos, oldnode)
		leafdecay_after_destruct(pos, oldnode)
	end,
	groups = {wood = 1,flammable=2,tree=1},
	sounds = sounds.wood(),
})

minetest.register_node("nodes:leaves", {
	description = "Wood",
	tiles = {"default_leaves.png"},
  walkable = false,
  climbable = true,
  drawtype = "allfaces_optional",
  paramtype = "light",
  sunlight_propagates = true,
	groups = {leaves = 1,flammable=1,leafdecay_drop = 1},
  on_timer = function(pos, elapsed)
    leafdecay_on_timer(pos)
  end,
  drop = "items:apple",
	sounds = sounds.leaves(),
})

minetest.register_node("nodes:rail_straight", {
	description = "Rail",
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
	tiles = {
		"default_stone.png",
	},
  node_box = {
    type = "fixed",
    fixed = {
      {0.3, -0.5, -0.5, 0.5, 0.1, 0.5},--left
      {-0.5, -0.5, -0.5, -0.3, 0.1, 0.5},--right
    },
  },
	inventory_image = "default_rail.png",
	wield_image = "default_rail.png",
  groups = {wood = 1,rail=1},
  sounds = sounds.stone(),
})

minetest.register_node("nodes:rail_turn", {
	description = "Rail",
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
	tiles = {
		"default_stone.png",
	},
  node_box = {
    type = "fixed",
    fixed = {
      --left,down,right,forward,up,backward
      {-0.5, -0.5, -0.5, -0.3, 0.1, 0.5},--left
      {0.3, -0.5, 0.3, 0.5, 0.1, 0.5},--corner
      {-0.5,-0.5,-0.5,0.5,0.1,-0.3},--corner
    },
  },
	inventory_image = "default_stone.png",
	wield_image = "default_rail.png",
  groups = {wood = 1,rail=1},
  sounds = sounds.stone(),
})

local uphill_nodebox = {}
--a few passes to construct uphill rails
for i = 1,16 do --right rail
  local pixel = (1/16)
                      --left down right front up back
  uphill_nodebox[i] = {
  0.3,  --left
  -0.5+(pixel*i)-pixel,  --bottom
  -0.5+(pixel*i)-pixel,  --back
  0.5,  --right
  -0.5+(pixel*10)+(pixel*i)-pixel, --top
  -0.5+(pixel*i)  --front
  }
end
for i = 1,16 do --left rail
  local pixel = (1/16)
                      --left down right front up back
  uphill_nodebox[i+16] = {
  -0.5,  --left
  -0.5+(pixel*i)-pixel,  --bottom
  -0.5+(pixel*i)-pixel,  --back
  -0.3,  --right
  -0.5+(pixel*10)+(pixel*i)-pixel, --top
  -0.5+(pixel*i)  --front
  }
end
for i = 1,16 do --base
  local pixel = (1/16)
                      --left down right front up back
  uphill_nodebox[i+32] = {
  -0.3,  --left
  -0.5+(pixel*i)-(pixel*2),  --bottom
  -0.5+(pixel*i)-pixel,  --back
  0.3,  --right
  -0.5+(pixel*1)+(pixel*i)-(pixel*2), --top
  -0.5+(pixel*i)  --front
  }
end

minetest.register_node("nodes:rail_uphill", {
	description = "Rail",
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
	tiles = {
		"default_stone.png",
	},
  node_box = {
    type = "fixed",
    fixed = uphill_nodebox,
  },
	inventory_image = "default_dirt.png",
	wield_image = "default_rail.png",
  groups = {wood = 1,rail=1},
  sounds = sounds.stone(),
})
