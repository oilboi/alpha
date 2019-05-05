-- Variables
local timer = 0
local key_down_already = {}

-- Move rightclick behavior to on_aux
minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_items) do
		if def.on_rightclick then
			minetest.override_item(name, {on_aux = def.on_rightclick})
			minetest.registered_items[name].on_rightclick = nil
		end
	end
end)

minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer > 0.1 then
		for _,player in ipairs(minetest.get_connected_players()) do
			local ctrl = player:get_player_control()
			local player_name = player:get_player_name()
			if ctrl.aux1 then
				if not key_down_already[player_name] then
					local pointed_thing = pointlib.update(player)
					local name = pointed_thing.itemstring
					local pos = pointed_thing.pos
					local def = minetest.registered_items[name]
					local node = minetest.get_node(pos)
					local clicker = player
					local itemstack = player:get_wielded_item()
					if def and def ~= ""  then
						local on_aux = def.on_aux
						if on_aux then
							on_aux(pos, node, clicker, itemstack)--, pointed_thing)
						end
					end
				end
				key_down_already[player_name] = true
			else
				key_down_already[player_name] = false
			end
		end
		timer = 0
	end
end)
