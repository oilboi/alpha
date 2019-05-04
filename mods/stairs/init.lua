

--this is a hack of the default nodes mod

-- Register stair
-- Node will be called nodes:stair_<subname>


--function nodes.register_stair(subname, recipeitem, groups, images, description,sounds, worldaligntex)
minetest.register_on_mods_loaded(function()

for name,def in pairs(minetest.registered_nodes) do
  if string.gsub(name, "nodes:", "") ~= name and minetest.get_item_group(name, "notstairs") == 0 then --simple check for if a nodes node

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

	minetest.register_node(":stairs:stair_" .. subname, {
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
			output = 'stairs:stair_' .. subname .. ' 8',
			recipe = {
				{"", "", recipeitem},
				{"", recipeitem, recipeitem},
				{recipeitem, recipeitem, recipeitem},
			},
		})
    minetest.register_craft({
			output = 'stairs:stair_' .. subname .. ' 8',
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
				{'stairs:stair_' .. subname, 'stairs:stair_' .. subname},
				{'stairs:stair_' .. subname, 'stairs:stair_' .. subname},
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
				recipe = 'stairs:stair_' .. subname,
				burntime = math.floor(baseburntime * 0.75),
			})
		end
	end
  end
end






for name,def in pairs(minetest.registered_nodes) do
  if string.gsub(name, "nodes:", "") ~= name and minetest.get_item_group(name, "notstairs") == 0 then --simple check for if a nodes node

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
	minetest.register_node(":stairs:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "wallmounted",
		is_ground_content = false,
		groups = new_groups,
		sounds = sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
		},
    after_place_node = function(pos, placer, itemstack, pointed_thing)
      local sneak = placer:get_player_control().sneak
      if sneak == true then
        minetest.set_node(pointed_thing.above,{name="stairs:slab_" .. subname,param2=0})
      else
        local undernode = minetest.get_node(pointed_thing.under)
        if undernode.name == "stairs:slab_" .. subname and undernode.param2 == 1 then
          minetest.set_node(pointed_thing.under,{name=name})
          minetest.remove_node(pointed_thing.above)
        else
          minetest.set_node(pointed_thing.above,{name="stairs:slab_" .. subname,param2=1})
        end
      end
    end,
    --turn into full node - doesn't let you when node above :(
    on_construct = function(pos)
      local pos_under = {x=pos.x,y=pos.y-1,z=pos.z}
      if minetest.get_node(pos_under).name == "stairs:slab_" .. subname then
        --minetest.set_node(pos_under,{name="stairs:slab_dirt",param2=0})
        --minetest.remove_node(pos)
        --minetest.set_node(pos_under,{name=name})
      end
    end,
	})

	if recipeitem then
		minetest.register_craft({
			output = 'stairs:slab_' .. subname .. ' 6',
			recipe = {
				{recipeitem, recipeitem, recipeitem},
			},
		})

		-- Use 2 slabs to craft a full block again (1:1)
		minetest.register_craft({
			output = recipeitem,
			recipe = {
				{'stairs:slab_' .. subname},
				{'stairs:slab_' .. subname},
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
				recipe = 'stairs:slab_' .. subname,
				burntime = math.floor(baseburntime * 0.5),
			})
		end
	end
  end
end


end)
