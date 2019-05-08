--eating items animation and success eat
bow_cycle = {} -- do this to hold player animation timer
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name() --get the players name
		if player:get_player_control().RMB == true then
			if player:get_wielded_item():get_definition().name == "bow:bow" then
				local inv = player:get_inventory()
				if inv:contains_item("main", "items:arrow") then
					--set up tables
					if not bow_cycle[name] then
						bow_cycle[name] = {}
						bow_cycle[name].timer = 0.2
					end
	        bow_cycle[name].timer = bow_cycle[name].timer + dtime

	        if bow_cycle[name].timer >= 0.2 then
	          bow_cycle[name].timer = 0
	  				local name = player:get_player_name() --get the players name
	          local pos = player:get_pos()
	          pos.y = pos.y + 1.5
	          local arrow = minetest.add_entity(pos,"bow:arrow")
	          local vel = player:get_player_velocity()
	          local dir = player:get_look_dir()
	          dir.x = vel.x + (dir.x * 15)
	    			dir.y = vel.y + (dir.y * 15 + 2)
	    			dir.z = vel.z + (dir.z * 15)
	          arrow:set_velocity(dir)
	          minetest.sound_play("bow", {
							pos = player:get_pos(),
							max_hear_distance = 16,
							gain = 1,
							--pitch = math.random(70,100)/100,
						})
						inv:remove_item("main", "items:arrow")
	        end
				end
			end
		elseif bow_cycle[name] then
			print(bow_cycle[name].timer)
			bow_cycle[name] = nil
		end
	end
end)


minetest.register_tool("bow:bow",
    {
        description = "Bow",
        groups = {bow = 1},
        inventory_image = "bow.png",
        wield_image = "bow.png",
        liquids_pointable = false,
    }
)

local arrow = {
  initial_properties = {
    physical = true, -- otherwise going uphill breaks
    visual = "mesh",
    collide_with_objects = false,
    collisionbox = {-0.1,-0.1,-0.1,0.1,0.1,0.1},
    mesh = "bow.obj",
	  textures = {"arrow_ent.png"},
	  visual_size = {x=0.5,y=0.5},
    timer = 0,
    speed = 0,
    --automatic_face_movement_dir = 0.0,
    --automatic_face_movement_max_rotation_per_sec = 65536, --65536
    --rider = "",
    pointable = false,
    hit = false,
  },
}
function arrow:on_activate(staticdata, dtime_s)

    self.object:set_acceleration({x=0,y=-10,z=0})

    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
        --restore old data
        if data then
        end
    end
end

function arrow:on_step(dtime)
  --make boat splash effects
  splash(self.object,self.object:get_pos())
  arrow:stop(self,dtime)
  arrow:set_rotation(self)
	arrow:hurt_mobs(self)
end

--punches mobs
function arrow:hurt_mobs(self)
	local pos = self.object:get_pos()
	for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
		if not object:is_player() and object:get_luaentity() and object:get_luaentity().mob == true then
			object:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 1},
		   }, nil)
			 self.object:remove()
		end
	end
end

--stop arrow on hit and drop item
function arrow:stop(self,dtime)
  local vel = self.object:get_velocity()
  if self.oldvel and ((self.oldvel.y < 0 and vel.y == 0) or (self.oldvel.x ~= 0 and vel.x == 0) or (self.oldvel.z ~= 0 and vel.z == 0)) then
    --self.hit = true
    --self.object:set_velocity(vector.new(0,0,0))
    --self.object:set_acceleration(vector.new(0,0,0))
    local pos = self.object:get_pos()
    minetest.sound_play("boing", {
  		pos = pos,
  		max_hear_distance = 40,
  		gain = 2,
  		pitch = math.random(70,110)/100,
  	})
		minetest.add_item(pos,"items:arrow")
		self.object:remove()
  end

  self.oldvel = vel
end

function arrow:set_rotation(self)
  if self.hit == true then return end
  local pos = self.object:get_pos()
  if self.old_pos then
    self.object:set_yaw(minetest.dir_to_yaw(vector.direction(pos, self.old_pos))+(pi*-0.5))
  end
  self.old_pos = pos
end


--test if a node is water
function arrow:testwater(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "water"))
end


function arrow:get_staticdata()
    return minetest.write_json({
    })
end

minetest.register_entity("bow:arrow", arrow)
