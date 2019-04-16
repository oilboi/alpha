--this is a hack of default fences in Minetest Game

--make fences out of every node
for name,def in pairs(minetest.registered_nodes) do

  --only do static textured objects
  if string.gsub(name, "nodes:", "") ~= name and type(def.tiles[1]) == "string" then

  --make base texture for wield item
  local texture = def.tiles[1]

  --remove the nodes: part of the string
  local name2 = string.gsub(name, "nodes:", "")

  --register crafting recipe
	minetest.register_craft({
		output = "fence:" .. name2 .. " 4",
		recipe = {
			{ name, 'group:stick', name },
			{ name, 'group:stick', name },
		}
	})

  --add to fence group
  def.groups.fence = 1

  --throw this all into a node registration using the nodes definition
  minetest.register_node("fence:" .. name2, {
		description = name2:gsub("^%l", string.upper).." Fence",
		drawtype = "nodebox",
		tiles = def.tiles,
    inventory_image = "default_fence_overlay.png^" .. texture .."^default_fence_overlay.png^[makealpha:255,126,126",
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
    sunlight_propagates = true,
    wield_image = "default_fence_overlay.png^" .. texture .."^default_fence_overlay.png^[makealpha:255,126,126",
		groups = def.groups,
		sounds = def.sounds,
    node_box = {
			type = "connected",
			fixed = {{-1/8, -1/2, -1/8, 1/8, 1/2, 1/8}},
			connect_front = {{-1/16,3/16,-1/2,1/16, 5/16,-1/8},{-1/16,-5/16,-1/2,1/16, -3/16,-1/8}},
			connect_left = {{-1/2,  3/16,-1/16,-1/8,5/16,1/16},{-1/2, -5/16,-1/16,-1/8,-3/16,1/16}},
		  connect_back = {{-1/16, 3/16,1/8,1/16,  5/16,1/2},{-1/16, -5/16,1/8,1/16,  -3/16,1/2}},
			connect_right = {{1/8,  3/16,-1/16,1/2, 5/16,1/16},{1/8,  -5/16,-1/16,1/2, -3/16,1/16}},
		},
    connects_to = {"group:fence", "group:wood", "group:tree", "group:wall"},
	})
  end
end
