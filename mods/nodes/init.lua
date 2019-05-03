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

minetest.register_node("nodes:cactus",{

      drawtype = "normal",  -- See "Node drawtypes"
      tiles = {"cactus_top.png", "cactus_bottom.png", "cactus_side.png"},
      damage_per_second = 4,
      selection_box = {
    		type = "fixed",
    		fixed = {
    			{-7/16, -8/16, -7/16, 7/16, 8/16, 7/16},
    		},
    	},
      collision_box = {
          type = "fixed",
          fixed = {
              {-0.18, -0.5, -0.18, 0.18, 0.2, 0.18},
          },
      },
      drawtype = "nodebox",
      node_box = {
        type = "fixed",
        fixed = {
          {-7/16, -8/16, -7/16,  7/16, 8/16,  7/16}, -- Main body
          {-8/16, -8/16, -7/16,  8/16, 8/16, -7/16}, -- Spikes
          {-8/16, -8/16,  7/16,  8/16, 8/16,  7/16}, -- Spikes
          {-7/16, -8/16, -8/16, -7/16, 8/16,  8/16}, -- Spikes
          {7/16,  -8/16,  8/16,  7/16, 8/16, -8/16}, -- Spikes
        },
      },
      sounds = sounds.wood(),
      groups = {wood=1,cactus=1}
})

minetest.register_node("nodes:tall_grass", {
	description = "Tall Grass",
	tiles = {"tall_grass.png"},
  drawtype = "plantlike",
  paramtype = "light",
  buildable_to = true,
  sunlight_propagates = true,
	groups = {flammable=1,instant=1,leaves=1,attached_node=1},
	sounds = sounds.leaves(),
  walkable = false,
  --make grass drop seeds when mined with shears
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
    if digger:get_wielded_item():to_string() ~= "" and digger:get_wielded_item():to_table().name == "tools:shears" then
      local obj = minetest.add_item(pos, "items:wheat_seeds")
      obj:get_luaentity().age = collection_age - 0.35 --make sure collected on dig - 0.5 for aesthetics
      obj:set_velocity({x=math.random(-2,2)*math.random(), y=obj:get_velocity().y, z=math.random(-2,2)*math.random()})
    end
  end,
  selection_box = {
		type = "fixed",
		fixed = {
				{-0.35, -0.5, -0.35, 0.35, 0.5, 0.35},
			},
		},
  drop = {
		max_items = 1,
		items = {
			{
				items = {'items:wheat_seeds'},
        rarity = 20,
			}
		}
	},
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

--copy minetest game's dig function for crops
local sugarcane_dig_up = function(pos)
  local pos2 = table.copy(pos)
  pos2.y = pos2.y + 1
  local node = minetest.get_node(pos2)
  if node.name == "nodes:sugarcane" then
    minetest.node_dig(pos2, node, nil)
  end
end

minetest.register_node("nodes:sugarcane", {
	description = "Sugar Cane",
	tiles = {"sugarcane.png"},
  drawtype = "plantlike",
  paramtype = "light",
  sunlight_propagates = true,
	groups = {flammable=1,instant=1,leaves=1,notstairs=1},
	sounds = sounds.leaves(),
  walkable = false,
  selection_box = {
		type = "fixed",
		fixed = {
				{-0.35, -0.5, -0.35, 0.35, 0.5, 0.35},
			},
		},
  --when placed make the sugarcane start a timer to grow
  on_construct = function(pos)
    local timer = minetest.get_node_timer(pos)
    if not timer:is_started() then
			timer:start(math.random(25,300))
		end
  end,
  --when the sugarcane timer expires try to find water near, if not, reset timer
  on_timer = function(pos, elapsed)
    if not minetest.find_node_near(pos, 6, "group:water") then
  		return false
  	end
    --if can grow (air above) then grow, else restart timer
    pos.y = pos.y + 1
    if minetest.get_node(pos).name == "air" then
      minetest.add_node(pos,{name="nodes:sugarcane"})
    else
      pos.y = pos.y - 1
      local timer = minetest.get_node_timer(pos)
      timer:start(math.random(25,300))
    end
  end,
  --when destroyed check if there's sugarcane below and then restart timer
  after_destruct = function(pos, oldnode)
    sugarcane_dig_up(pos)
    pos.y = pos.y - 1
    local timer = minetest.get_node_timer(pos)
    if minetest.get_node(pos).name == "nodes:sugarcane" then
      timer:start(math.random(25,300))
    end
  end,
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
  --sunlight_propagates = false,
	groups = {leaves = 1,flammable=1,leafdecay_drop = 1},
  on_timer = function(pos, elapsed)
    leafdecay_on_timer(pos)
  end,
  --make leaves drop leaves when mined with shears
  after_dig_node = function(pos, oldnode, oldmetadata, digger)
    if digger:get_wielded_item():to_string() ~= "" and digger:get_wielded_item():to_table().name == "tools:shears" then
      local obj = minetest.add_item(pos, "nodes:leaves")
      obj:get_luaentity().age = collection_age - 0.35 --make sure collected on dig - 0.5 for aesthetics
      obj:set_velocity({x=math.random(-2,2)*math.random(), y=obj:get_velocity().y, z=math.random(-2,2)*math.random()})
    end
  end,
  drop = {
		max_items = 1,
		items = {
			{
				-- player will get apple with 1/20 chance
				items = {'items:apple'},
				rarity = 20,
			},
			{
				items = {'items:stick'},
        rarity = 20,
			}
		}
	},
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
