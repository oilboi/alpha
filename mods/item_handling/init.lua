--this is built off of Wuzzy's Mineclone2 item magnet
--let's simplify item collection mechanics to the basics
collection_age = 2.5
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 or not minetest.settings:get_bool("enable_damage") then
			local pos = player:get_pos()
			local inv = player:get_inventory()
			local eyepos = {x=pos.x,y=pos.y + 1.5 --[[The player's eyesight]],z=pos.z}

			--Check for collection
			for _,object in ipairs(minetest.get_objects_inside_radius(eyepos, 3)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					local objpos = object:getpos()
					if objpos.y >= pos.y - 0.5 and object:get_luaentity().age > collection_age and inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
            if object:get_luaentity().collected ~= true then

						-- Collection
						--if vector.distance(checkpos, object:get_pos()) <= item_drop_settings.radius_collect and not object:get_luaentity()._removed then
							-- Ignore if itemstring is not set yet
							if object:get_luaentity().itemstring ~= "" then
                object:move_to(eyepos,true)
								--stop item from moving down
								object:get_luaentity().is_moving = false
								object:get_luaentity().physical = false
                object:get_luaentity().collected = true
								object:set_acceleration({x=0,y=0,z=0})
								object:set_velocity({x=0,y=0,z=0})
                --run this in .after so the player sees the animation
                minetest.after(0.1,function(object)
                  if object:get_luaentity() then
    								inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
    								minetest.sound_play("collection", {
    									pos = pos,
    									max_hear_distance = 16,
    									gain = 1.0,
    								})
    								-- Destroy entity
    								object:remove()
                  end
                end,object)
							end
					end
					end
			  end
			end
		end
	end
end)

--drop nodes when mined
function minetest.handle_node_drops(pos, drops, digger)
	for _,item in ipairs(drops) do
		local count
		if type(item) == "string" then
			count = ItemStack(item):get_count()
		else
			count = item:get_count()
		end
		local drop_item = ItemStack(item)
		drop_item:set_count(1)

		for i=1,count do
			local obj = core.add_item(pos, drop_item)
			if obj ~= nil then
        obj:get_luaentity().age = collection_age - 0.35 --make sure collected on dig - 0.5 for aesthetics
				obj:set_velocity({x=math.random(-2,2)*math.random(), y=obj:get_velocity().y, z=math.random(-2,2)*math.random()})
			end
		end
	end
end
