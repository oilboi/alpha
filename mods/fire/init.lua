minetest.register_node("fire:fire",
{
  description = "Fire",
  tiles = {
		{
			name = "fire_basic_flame_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 1
			},
		},
	},
  groups = {fire = 1,instant=1},
  sounds = sounds.stone(),
  paramtype = "light",
  --drop = "",
  drawtype = "nodebox",
  node_box = {
    type = "connected",
    --fixed = {{-1/2, -1/2, -1/2, 1/2, -3/8, 1/2}},
    connect_front = {{-1/2, -1/2, -1/2, 1/2, 1/2, -3/8}},

    connect_left = {{-1/2,  -1/2, -1/2,-3/8, 1/2,1/2}},

    connect_back = {{-1/2,  -1/2, 3/8,1/2, 1/2,1/2}},

    connect_right = {{3/8,  -1/2, -1/2,1/2, 1/2,1/2}},

    connect_top = {{-1/2,  3/8, -1/2,1/2, 1/2,1/2}},
    connect_bottom = {{-1/2,  -1/2, -1/2,1/2, -3/8,1/2}},
  },
  connects_to = {"group:flammable"},
}
)
