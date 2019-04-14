--set the default stacks
minetest.register_on_mods_loaded(function()
	for item,def in pairs(minetest.registered_items) do
		minetest.override_item(item, {stack_max = 64})
	end
	for node,def in pairs(minetest.registered_nodes) do
		minetest.override_item(node, {stack_max = 64})
	end
	for node,def in pairs(minetest.registered_tools) do
		minetest.override_item(node, {stack_max = 1})
	end
end)

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
					local objpos = object:get_pos()
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
											pitch = math.random(60,120)/100,
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
			local obj = minetest.add_item(pos, drop_item)
			if obj ~= nil then
        obj:get_luaentity().age = collection_age - 0.35 --make sure collected on dig - 0.5 for aesthetics
				obj:set_velocity({x=math.random(-2,2)*math.random(), y=obj:get_velocity().y, z=math.random(-2,2)*math.random()})
			end
		end
	end
end

--throw a single item at player's speed
--sneak throw, throws whole stack
function minetest.item_drop(itemstack, dropper, pos)
	local dropper_is_player = dropper and dropper:is_player()
	local p = table.copy(pos)
	local vel = vector.new(0,0,0)

	if dropper_is_player then
		p.y = p.y + 1.5
		vel = dropper:get_player_velocity()
	end

	local item = itemstack:take_item(1)
	local obj = core.add_item(p, item)
	if obj then
		if dropper_is_player then
			local dir = dropper:get_look_dir()
			dir.x = vel.x + (dir.x * 2.9)
			dir.y = vel.y + (dir.y * 2.9 + 2)
			dir.z = vel.z + (dir.z * 2.9)
			obj:set_velocity(dir)
			obj:get_luaentity().dropped_by = dropper:get_player_name()
		end
		return itemstack
	end
end


--sound for craft success
minetest.register_on_craft(function(itemstack, player, old_craft_grid, craft_inv)
	minetest.sound_play("clack", {
		pos = player:get_pos(),
		max_hear_distance = 16,
		gain = 1.0,
		pitch = math.random(30,60)/100,
	})
end)

--eating items animation and success eat
eating_animation = {} -- do this to hold player animation timer
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_player_control().RMB == true then
			if player:get_wielded_item():get_definition().food then
				local name = player:get_player_name() --get the players name

				--set up tables
				if not eating_animation[name] then
					eating_animation[name] = {}
					eating_animation[name].timer = 0
					eating_animation[name].cycles = 0
				end

				eating_animation[name].timer = eating_animation[name].timer + dtime

				--when at cycle do particles and repeat
				if eating_animation[name].timer >= 0.15 and eating_animation[name].cycles < 10 then

					eating_animation[name].timer = 0

					eating_animation[name].cycles = eating_animation[name].cycles + 1 --add a cycle

					local pos = player:get_pos()
					pos.y = pos.y + 1.5


					minetest.sound_play("eat", {
						pos = player:get_pos(),
						max_hear_distance = 16,
						gain = 0.03,
						pitch = math.random(70,100)/100,
					})
					local tile = {player:get_wielded_item():get_definition().inventory_image}
			    tool_break_explosion(tile,pos,10,1,2,5)

				elseif eating_animation[name].cycles >= 10 then-- eat item
					--replace the item
					local inv = player:get_inventory()
					local item = player:get_wielded_item()
					local index = player:get_wield_index()
					local count = item:get_count()
					local stack = inv:get_stack("main", index)

					eating_animation[name] = nil
					--hp add
					player:set_hp(player:get_hp()+player:get_wielded_item():get_definition().food, "set_hp")

					--remove the item after
					player:set_wielded_item(stack:take_item(count-1))

					--sounds and particles
					minetest.sound_play("eat_complete", {
						pos = player:get_pos(),
						max_hear_distance = 16,
						gain = 1,
						pitch = math.random(60,110)/100,
					})
					local pos = player:get_pos()
					pos.y = pos.y + 1.5
					local tile = {player:get_wielded_item():get_definition().inventory_image}
			    tool_break_explosion(tile,pos,150,1,2,5)
				end
			else
				--reset the tables
				local name = player:get_player_name() --get the players name
				eating_animation[name] = nil
			end
			--print(player)
			--print(player:get_player_name())
		else
			--reset the variables if not right click
			local name = player:get_player_name() --get the players name
			eating_animation[name] = nil
		end
	end
end)
