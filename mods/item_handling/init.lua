--let's simplify item collection mechanics to the basics
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 or not minetest.settings:get_bool("enable_damage") then
			local pos = player:get_pos()
			local inv = player:get_inventory()
			local eyepos = {x=pos.x,y=pos.y + 1.5 --[[The player's eyesight]],z=pos.z}

			--Check for collection
			for _,object in ipairs(minetest.get_objects_inside_radius(eyepos, 3)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().age > 1 and inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
            if object:get_luaentity().collected ~= true then

						-- Collection
						--if vector.distance(checkpos, object:get_pos()) <= item_drop_settings.radius_collect and not object:get_luaentity()._removed then
							-- Ignore if itemstring is not set yet
							if object:get_luaentity().itemstring ~= "" then
                object:move_to(eyepos,true)
                object:get_luaentity().collected = true
                minetest.after(0.1,function(object)
                  if object then
    								inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
                    --[[
    								minetest.sound_play("item_drop_pickup", {
    									pos = pos,
    									max_hear_distance = 16,
    									gain = 1.0,
    								})
                    ]]--
    								-- Destroy entity
    								-- This just prevents this section to be run again because object:remove() doesn't remove the item immediately.
    								object:remove()
                  end
                end,object)
							end
					end

          --[[
					if not collected then
						if object:get_luaentity()._magnet_timer > 1 then
							object:get_luaentity()._magnet_timer = -item_drop_settings.magnet_time
							object:get_luaentity()._magnet_active = false
						elseif object:get_luaentity()._magnet_timer < 0 then
							object:get_luaentity()._magnet_timer = object:get_luaentity()._magnet_timer + dtime
						end
            ]]--
					end


				end
			end
		end
	end
end)
