--this is where all the craft recipes are located
minetest.register_craft({
	type = "shapeless",
	output = "nodes:wood 4",
	recipe = {"nodes:tree"},
})

minetest.register_craft({
	output = "items:stick 4",
	recipe = {
		{"nodes:wood"},
		{"nodes:wood"},
	}
})

minetest.register_craft({
	output = "tools:shears",
	recipe = {
		{"","items:iron"},
		{"items:iron",""},
	}
})
minetest.register_craft({
	output = "tools:shears",
	recipe = {
		{"items:iron",""},
		{"","items:iron"},
	}
})
minetest.register_craft({
	output = "items:paper",
	recipe = {
		{"nodes:sugarcane","nodes:sugarcane","nodes:sugarcane"},
	}
})

minetest.register_craft({
	output = "painting:painting_inv",
	recipe = {
		{"items:stick","items:stick","items:stick"},
		{"items:stick","items:paper","items:stick"},
		{"items:stick","items:stick","items:stick"},
	}
})

--register recipes for tools
local outputs = {"wood","stone","iron","gold","diamond"}
local inputs = {"nodes:wood","nodes:cobble","items:iron","items:gold","items:diamond"}

for i = 1,table.getn(outputs) do
  --pickaxes
  minetest.register_craft({
  	output = "tools:"..outputs[i].."_pickaxe",
  	recipe = {
  		{inputs[i], inputs[i], inputs[i]},
  		{"", "items:stick", ""},
  		{"", "items:stick", ""}
  	}
  })
  --axes
  minetest.register_craft({
    output = "tools:"..outputs[i].."_axe",
    recipe = {
      {inputs[i], inputs[i], ""},
      {inputs[i], "items:stick", ""},
      {"", "items:stick", ""}
    }
  })
	--axes inverse
  minetest.register_craft({
    output = "tools:"..outputs[i].."_axe",
    recipe = {
      {"", inputs[i], inputs[i]},
      {"", "items:stick", inputs[i]},
      {"", "items:stick", ""}
    }
  })
  --shovels
  minetest.register_craft({
    output = "tools:"..outputs[i].."_shovel",
    recipe = {
      {"", inputs[i], ""},
      {"", "items:stick", ""},
      {"", "items:stick", ""}
    }
  })
	--hoes
  minetest.register_craft({
    output = "tools:"..outputs[i].."_hoe",
    recipe = {
      {inputs[i], inputs[i], ""},
      {"", "items:stick", ""},
      {"", "items:stick", ""}
    }
  })
	--hoes inverse
	minetest.register_craft({
    output = "tools:"..outputs[i].."_hoe",
    recipe = {
      {"", inputs[i], inputs[i]},
      {"", "items:stick", ""},
      {"", "items:stick", ""}
    }
  })
  --paxels
  minetest.register_craft({
    output = "tools:"..outputs[i].."_paxel",
    type = "shapeless",
    recipe =  {"tools:"..outputs[i].."_shovel", "tools:"..outputs[i].."_pickaxe", "tools:"..outputs[i].."_axe"},
  })
end

minetest.register_craft({
	output = "chest:chest",
	recipe = {
		{"nodes:wood", "nodes:wood", "nodes:wood"},
		{"nodes:wood", "",           "nodes:wood"},
		{"nodes:wood", "nodes:wood", "nodes:wood"}
	}
})

--cooking
minetest.register_craft({
	output = "furnace:furnace",
	recipe = {
		{"nodes:cobble", "nodes:cobble", "nodes:cobble"},
		{"nodes:cobble", "",             "nodes:cobble"},
		{"nodes:cobble", "nodes:cobble", "nodes:cobble"}
	}
})

minetest.register_craft({
	type = "cooking",
	output = "items:coal",
	recipe = "nodes:coal",
})

minetest.register_craft({
	type = "cooking",
	output = "items:iron",
	recipe = "nodes:iron",
})

minetest.register_craft({
	type = "cooking",
	output = "items:gold",
	recipe = "nodes:gold",
})

minetest.register_craft({
	type = "cooking",
	output = "nodes:stone",
	recipe = "nodes:cobble",
})

---
minetest.register_craft({
	output = "torch:torch 4",
	recipe = {
		{ "items:coal" },
		{ "items:stick" },
	}
})


minetest.register_craft({
	output = "craft_table:craft_table",
	recipe = {
		{"nodes:wood", "nodes:wood"},
		{"nodes:wood", "nodes:wood"}
	}
})

minetest.register_craft({
	output = "boat:boat",
	recipe = {
		{"group:wood", "", "group:wood"},
		{"group:wood","group:wood", "group:wood"}
	}
})

minetest.register_craft({
	output = "items:bread",
	recipe = {
		{"items:wheat","items:wheat","items:wheat"},
	}
})

minetest.register_craft({
	output = "bow:bow",
	recipe = {
		{"group:string", "group:stick", ""},
		{"group:string","", "group:stick"},
		{"group:string", "group:stick", """}
	}
})

--fuels

minetest.register_craft({
	type = "fuel",
	recipe = "group:wood",
	burntime = 30,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:tree",
	burntime = 60,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:leaves",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:stick",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:paper",
	burntime = 10,
})

minetest.register_craft({
	type = "fuel",
	recipe = "group:coal",
	burntime = 240,
})
