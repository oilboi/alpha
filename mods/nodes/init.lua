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
local levels = {1,1,2,3}

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
  liquid_viscosity = 1,
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
  groups = {water = 1},
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
  liquid_viscosity = 1,
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
  groups = {water = 1},
  liquidtype = "flowing",
  liquid_alternative_flowing = "nodes:water_flowing",
  liquid_alternative_source = "nodes:water",
  sounds = sounds.water(),
}
)

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
	groups = {wood = 1,flammable=2},
	sounds = sounds.wood(),
})

minetest.register_node("nodes:leaves", {
	description = "Wood",
	tiles = {"default_leaves.png"},
  drawtype = "allfaces_optional",
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




--this is a hack of the default nodes mod

-- Register stair
-- Node will be called nodes:stair_<subname>


--function nodes.register_stair(subname, recipeitem, groups, images, description,sounds, worldaligntex)
for name,def in pairs(minetest.registered_nodes) do
  if string.gsub(name, "nodes:", "") ~= name then --simple check for if a nodes node

  local subname = string.gsub(name, "nodes:", "") --make it the name of the node
  local recipeitem = name
  local groups = def.groups
  local images = def.tiles
  local description = string.gsub(name, "nodes:", ""):gsub("^%l", string.upper).." Stair"
  local sounds = def.sounds
  local worldaligntex = false

	-- Set backface culling and world-aligned textures
	local stair_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			stair_images[i] = {
				name = image,
				backface_culling = true,
			}
			if worldaligntex then
				stair_images[i].align_style = "world"
			end
		else
			stair_images[i] = table.copy(image)
			if stair_images[i].backface_culling == nil then
				stair_images[i].backface_culling = true
			end
			if worldaligntex and stair_images[i].align_style == nil then
				stair_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.stair = 1
	minetest.register_node(":nodes:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.0, 0.5},
				{-0.5, 0.0, 0.0, 0.5, 0.5, 0.5},
			},
		},
	})


	if recipeitem then
		-- Recipe matches appearence in inventory
		minetest.register_craft({
			output = 'nodes:stair_' .. subname .. ' 8',
			recipe = {
				{"", "", recipeitem},
				{"", recipeitem, recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})
    minetest.register_craft({
			output = 'nodes:stair_' .. subname .. ' 8',
			recipe = {
				{recipeitem, "", ""},
				{recipeitem, recipeitem, ""},
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use nodes to craft full blocks again (1:1)
		minetest.register_craft({
			output = recipeitem .. ' 3',
			recipe = {
				{'nodes:stair_' .. subname, 'nodes:stair_' .. subname},
				{'nodes:stair_' .. subname, 'nodes:stair_' .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'nodes:stair_' .. subname,
				burntime = math.floor(baseburntime * 0.75),
			})
		end
	end
  end
end






for name,def in pairs(minetest.registered_nodes) do
  if string.gsub(name, "nodes:", "") ~= name then --simple check for if a nodes node

  local subname = string.gsub(name, "nodes:", "") --make it the name of the node
  local recipeitem = name
  local groups = def.groups
  local images = def.tiles
  local description = string.gsub(name, "nodes:", ""):gsub("^%l", string.upper).." Slab"
  local sounds = def.sounds
  local worldaligntex = false

	-- Set world-aligned textures
	local slab_images = {}
	for i, image in ipairs(images) do
		if type(image) == "string" then
			slab_images[i] = {
				name = image,
			}
			if worldaligntex then
				slab_images[i].align_style = "world"
			end
		else
			slab_images[i] = table.copy(image)
			if worldaligntex and image.align_style == nil then
				slab_images[i].align_style = "world"
			end
		end
	end
	local new_groups = table.copy(groups)
	new_groups.slab = 1
	minetest.register_node("nodes:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
    --turn into full node - doesn't let you when node above :(
    on_construct = function(pos)
      local pos_under = {x=pos.x,y=pos.y-1,z=pos.z}
      if minetest.get_node(pos_under).name == "nodes:slab_" .. subname then
        minetest.remove_node(pos)
        minetest.set_node(pos_under,{name=name})
      end
    end,
	})

	if recipeitem then
		minetest.register_craft({
			output = 'nodes:slab_' .. subname .. ' 6',
			recipe = {
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use 2 slabs to craft a full block again (1:1)
		minetest.register_craft({
			output = recipeitem,
			recipe = {
				{'nodes:slab_' .. subname},
				{'nodes:slab_' .. subname},
			},
		})

		-- Fuel
		local baseburntime = minetest.get_craft_result({
			method = "fuel",
			width = 1,
			items = {recipeitem}
		}).time
		if baseburntime > 0 then
			minetest.register_craft({
				type = "fuel",
				recipe = 'nodes:slab_' .. subname,
				burntime = math.floor(baseburntime * 0.5),
			})
		end
	end
  end
end
