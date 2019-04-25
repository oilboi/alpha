--create farming in here because it's so big
--basically instead of the actual farming nodes activating themselves
--the farmland nodes do all the work

minetest.register_node(":nodes:dry_farmland",
{
  description = "Dry Farmland",
  tiles = {"farmland_dry.png","default_dirt.png"},
  groups = {farmland = 1,dry=1,dirt=1},
  sounds = sounds.dirt(),
  drop = "nodes:dirt",
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {
      {-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
    },
  },
  on_construct = function(pos)
    local timer = minetest.get_node_timer(pos)
    if not timer:is_started() then
			timer:start(math.random(5,30))
		end
  end,
  --when the wet farmland timer expires try to find water near, if not, turn to dirt
  on_timer = function(pos, elapsed)
    if not minetest.find_node_near(pos, 2, "group:water") then
  		minetest.set_node(pos,{name="nodes:dirt"})
      --remove the crop above
      local above_node = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name
      local nodely = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
      if minetest.get_item_group(above_node,"farming") > 0 then
        minetest.node_dig({x=pos.x,y=pos.y+1,z=pos.z}, nodely, nil)
        minetest.sound_play(sounds.leaves().place.name, {
          pos = {x=pos.x,y=pos.y+1,z=pos.z},
          max_hear_distance = 100,
          gain = 1.0,
          pitch = math.random(70,100)/100,
        })
      end
    else
      minetest.set_node(pos,{name="nodes:wet_farmland"})
  	end
  end,
}
)
minetest.register_node(":nodes:wet_farmland",
{
  description = "Wet Farmland",
  tiles = {"farmland_wet.png","default_dirt.png"},
  groups = {farmland = 1,wet=1,dirt=1},
  sounds = sounds.dirt(),
  drop = "nodes:dirt",
  drawtype = "nodebox",
  node_box = {
    type = "fixed",
    fixed = {
      {-0.5, -0.5, -0.5, 0.5, 0.4, 0.5},
    },
  },
  on_construct = function(pos)
    local timer = minetest.get_node_timer(pos)
    if not timer:is_started() then
			timer:start(math.random(5,30))
		end
  end,
  --when the wet farmland timer expires try to find water near, if not, reset timer
  on_timer = function(pos, elapsed)
    --remove the crop above
    local above_node = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name
    local nodely = minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z})
    if not minetest.find_node_near(pos, 2, "group:water") then
  		minetest.set_node(pos,{name="nodes:dry_farmland"})
      if minetest.get_item_group(above_node,"farming") > 0 then
        minetest.node_dig({x=pos.x,y=pos.y+1,z=pos.z}, nodely, nil)
        minetest.sound_play(sounds.leaves().place.name, {
          pos = {x=pos.x,y=pos.y+1,z=pos.z},
          max_hear_distance = 100,
          gain = 1.0,
          pitch = math.random(70,100)/100,
        })
      end
    else
      --set dirt if crop isn't above
      if above_node ~= "air" and minetest.get_item_group(above_node,"farming") == 0 then
        minetest.set_node(pos,{name="nodes:dirt"})
        return
      end
      --set the crop above stage
      local stage = minetest.get_item_group(above_node,"stage")
      local max   = minetest.get_item_group(above_node,"max")
      if stage < max then
        --next stage
        minetest.set_node({x=pos.x,y=pos.y+1,z=pos.z},{name=above_node:sub(1, -2)..stage+1})
      end
      --do this to reset the timer
      minetest.set_node(pos,{name="nodes:wet_farmland"})
  	end
  end,
}
)

--register wheat using mineclone2 textures
local wheat_max = 7 --use this to tell when to stop growing
--only drop crop on max stage
for i = 0,7 do
  local drops = ""
  if i == wheat_max then
    drops = {
  		max_items = 4,
  		items = {
  			{
  				items = {'items:wheat'},
  			},
        {
          items = {"items:wheat_seeds"},
        },
        {
          items = {'items:wheat'},
          rarity = 5,
        },
        {
          items = {'items:wheat'},
          rarity = 5,
        },
        {
          items = {"items:wheat_seeds"},
          rarity = 5,
        },
  		}
  	}
  end
  minetest.register_node(":nodes:wheat_"..i, {
  	description = "Wheat Stage "..i,
  	tiles = {"mcl_farming_wheat_stage_"..i..".png"},
    drawtype = "plantlike",
    paramtype = "light",
    sunlight_propagates = true,
  	groups = {instant=1,farming=1,stage=i,wheat=1,max=wheat_max},
  	sounds = sounds.leaves(),
    walkable = false,
    drop = drops,
    selection_box = {
  		type = "fixed",
  		fixed = {
  				{-0.35, -0.5, -0.35, 0.35, -0.5+(i*0.1429), 0.35}, --try to get pixel perfect selection box
  			},
  		},
  })
end

minetest.register_craftitem(":items:wheat_seeds", {
	description = "Wheat Seeds",
	inventory_image = "wheat_seeds.png",
	groups = {food = 1, flammable = 2},

  on_place = function(itemstack, placer, pointed_thing)
    --only let farmers farm pointing directly on top of the farmland
    --ie, planting seeds
    local compare = vector.subtract(pointed_thing.above,pointed_thing.under)
    if compare.y ~= 1 then return end

    --copy the under table
    local undernode = table.copy(pointed_thing.under)
    --then get if pointing at farmland
    local groupunder = minetest.get_item_group(minetest.get_node(undernode).name,"farmland")
    --then make sure that there's air above before planting
    undernode.y = undernode.y + 1
    local nodeabove = minetest.get_node(undernode).name

    --now compare and plant if successful
    if groupunder > 0 and nodeabove == "air" then
      --reuse undernode because it's above
      minetest.add_node(undernode,{name="nodes:wheat_0"})

      --then take the item and success!
      itemstack:take_item()
      return(itemstack)
    end
  end,
})
