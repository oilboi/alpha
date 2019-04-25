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
    if not minetest.find_node_near(pos, 2, "group:water") then
  		minetest.set_node(pos,{name="nodes:dry_farmland"})
    else
      --do this to reset the timer
      minetest.set_node(pos,{name="nodes:wet_farmland"})
  	end
  end,
}
)
