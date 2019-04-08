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


--register recipes for tools
local outputs = {"wood","stone","iron","gold","diamond"}
local inputs = {"nodes:wood","nodes:cobble","items:iron","items:iron","items:diamond"}

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
  --shovels
  minetest.register_craft({
    output = "tools:"..outputs[i].."_shovel",
    recipe = {
      {"", inputs[i], ""},
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