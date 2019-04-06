print("initialized sounds")
sounds = {}

--the stone table
function sounds.stone(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "stone", gain = 0.2}
	table.dug = table.dug or
			{name = "stone", gain = 1.0}
	table.place = table.place or
			{name = "stone", gain = 1.0}
  table.dig = table.dig or
    	{name = "stone", gain = 0.35}
	--default.node_sound_defaults(table)
	return table
end

--the dirt table
function sounds.dirt(table)
	table = table or {}
	table.footstep = table.footstep or
			{name = "dirt", gain = 0.2}
	table.dug = table.dug or
			{name = "grass_break", gain = 0.5}
	table.place = table.place or
			{name = "dirt", gain = 1.0}
  table.dig = table.dig or
    	{name = "dirt", gain = 0.35}
	--default.node_sound_defaults(table)
	return table
end
