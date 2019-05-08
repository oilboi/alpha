local pig = {
  initial_properties = {
    physical = true, -- otherwise going uphill breaks
    makes_footstep_sound = true,
    visual = "mesh",
    collide_with_objects = false,
    collisionbox = {-0.45, -0.01, -0.45, 0.45, 0.865, 0.45},
    mesh = "pig.b3d",
    textures = {"blank.png","pig.png","blank.png"},
    visual_size = {x=2.5,y=2.5},
    automatic_face_movement_dir = -90.0,
    automatic_face_movement_max_rotation_per_sec = 65536, --65536
    rider = "",
    hp_max = 5,
    pointable = false,
  },
  mob = true,
  timer = 0,
  speed = 0,
  walk_start = 0,
  walk_end = 40,
  pig_sound = "mobs_pig",
  angry_pig_sound = "mobs_pig_angry",
}

--restore variables
function pig:on_activate(staticdata, dtime_s)
    --self.object:set_acceleration({x=0,y=-10,z=0})


    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
        --restore old data
        if data then
          print("restoring old data")
          self.rider = data.rider
          if minetest.get_player_by_name(self.rider) then
            minetest.get_player_by_name(self.rider):set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
          else
            self.rider = ""
          end

          self.timer = data.timer
          self.move_goal = data.move_goal
          self.speed_goal = data.speed_goal
          self.yaw = data.yaw
          self.turn_timer = data.turn_timer
          self.turn_goal = data.turn_goal
          self.turn_intensity = data.turn_intensity
          self.turn_direction = data.turn_direction
          self.jump_timer = data.jump_timer
          self.oink_timer = data.oink_timer
          self.oink_timer_goal = data.oink_timer_goal
          self.hurt_cooldown = data.hurt_cooldown
          self.particle_hurt = data.particle_hurt
          if data.hp then
            self.object:set_hp(data.hp)
          end
        end
    else --create new data
      print("creating new data")

      self.rider =  ""

      self.timer = 0
      self.move_goal = math.random(1,4)
      self.speed_goal = math.random()
      self.yaw = pi * math.random()
      self.turn_timer = 0
      self.turn_goal =  math.random(1,3)
      self.turn_intensity = 1
      self.turn_direction = math.random(-1,1)
      self.jump_timer = 0
      self.oink_timer = 0
      self.oink_timer_goal = math.random(3,20)
      self.hurt_cooldown = 0
      self.particle_hurt = 0
    end
end

function pig:on_step(dtime)

  self.timer = self.timer + dtime

  pig:fall_damage(self)

  pig:jump(self,dtime)

  pig:friction(self)
  pig:float(self)

  pig:turn(self,dtime)
  pig:move(self)

  --make the object flow in water
  set_flow(self.object:get_pos(),self.object,7)

  --make boat splash effects
  splash(self.object,self.object:get_pos())

  --boat:set_rotation(self)
  self.old_pos = self.object:get_pos()


  pig:animation(self)
  pig:oink(self,dtime)

  pig:hurt(self,dtime)
end

--oink!
function pig:oink(self,dtime)
  self.oink_timer = self.oink_timer + dtime
  if self.oink_timer >= self.oink_timer_goal then
    self.oink_timer = 0
    self.oink_timer_goal = math.random(3,20)

    local pos = self.object:get_pos()
    minetest.sound_play(self.pig_sound, {
  		pos = pos,
  		max_hear_distance = 40,
  		gain = 2,
  		pitch = math.random(70,110)/100,
  	})
  end
end

--set animation based on speed
function pig:animation(self)

  local vel = self.object:get_velocity()
  local speed = (math.abs(vel.x)+math.abs(vel.z))*30 --base it on average speed

  self.object:set_animation_frame_speed(speed)

  --start the animation
  if not self.anim then
    self.anim = true
    self.object:set_animation({
  		x = self.walk_start,
  		y = self.walk_end},
      0,
      0,
      true)
  end

end

--primitive jumping over nodes if stopped
function pig:jump(self,dtime)
  self.jump_timer = self.jump_timer + dtime
  local vel = self.object:getvelocity()
  --try a jump on timer, only if on ground
  if self.jump_timer > 0.25 and (vel.y == 0 or pig:testwater(self.object:get_pos()) > 0) then
    self.jump_timer = 0
    if vel.x == 0 or vel.z == 0 then
      self.object:set_velocity(vector.new(vel.x,7,vel.z))
    end
  end
end

function pig:turn(self,dtime)
  self.turn_timer = self.turn_timer + dtime

  --make the mob randomly turn
  if self.turn_timer >= self.turn_goal then

    self.turn_timer = 0
    self.turn_goal = math.random(1,3)

    self.turn_intensity = math.random(1,5)
    self.turn_direction = math.random(-1,1) --can hit 0 to go straight
  end


  --only do turning logic if turning to save cpu
  if self.turn_direction ~= 0 then
    self.yaw = self.yaw + (dtime * (self.turn_intensity*self.turn_direction))

    --overshoot protection (pi yaw wrap around)
    if self.yaw > pi then
      self.yaw = self.yaw - pi + (-pi)
    elseif self.yaw < -pi then
      self.yaw = self.yaw - (-pi) + pi
    end
    self.object:setyaw(self.yaw)
  end
end

--move with pig around
function pig:move(self)
  --pig has a rider
  if self.rider ~= "" and self.rider ~= nil then

    local player = minetest.get_player_by_name(self.rider)
    --cancel if somehow the player isn't riding
    if player:get_attach() ~= self.object then
      self.rider = ""
      return
    end
    if player:get_player_control().up == true then
      local playeryaw = player:get_look_horizontal()
      local direction = minetest.yaw_to_dir(playeryaw)
      local dir = vector.divide(direction,10)
      self.object:add_velocity({x=dir.x,y=0,z=dir.z})
    end
  --pig is wandering around
  else
    --Searched Minetest mobs: https://notabug.org/TenPlus1/mobs_redo/src/master/api.lua#L232
    local vel = self.object:get_velocity()
    self.object:set_velocity({
      x = (math.cos(self.yaw)*self.speed_goal),
      y = vel.y,
      z = (math.sin(self.yaw)*self.speed_goal),
    })
    if self.timer > self.move_goal then
      self.timer = 0
      self.move_goal = math.random(1,4)
      self.speed_goal = math.random()*math.random(1,5)
      --self.object:add_velocity(vector.new(math.random(-2,2)*math.random(),0,math.random(-2,2)*math.random()))
    end
  end
end

--makes the boat float
function pig:float(self)
  local pos = self.object:get_pos()

  pos.y = pos.y + 0.3

  local in_water =  pig:testwater(pos)

  if in_water > 0 then
    self.object:add_velocity({x=0,y=0.15,z=0})
  else
    self.object:add_velocity({x=0,y=-0.15,z=0})
  end

  pos.y = pos.y - 0.5
  --try to apply gravity
  if minetest.get_item_group(minetest.get_node(pos).name, "water") == 0 and in_water == 0 then
    self.object:set_acceleration({x=0,y=-10,z=0})
  else
    self.object:set_acceleration({x=0,y=0,z=0})
  end

end

--do fall damage
function pig:fall_damage(self)
  local vel = self.object:get_velocity()
  if self.oldvel and self.oldvel.y < -12 and vel.y == 0 then
    local damage = math.abs(self.oldvel.y)/4
    self.object:punch(self.object, 1.0, {
		full_punch_interval = 1.0,
		damage_groups = {fleshy = damage},
	   }, nil)
  end
  self.oldvel = vel
end

--try to ride pig
function pig:on_rightclick(clicker)
  local name = clicker:get_player_name()
  if self.rider == nil or self.rider == "" then
    self.rider = name
    clicker:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
  elseif self.rider == name then
    self.rider = ""
    clicker:set_detach()
  end
end

--rotate pig
function pig:set_rotation(self)
  local pos = self.object:get_pos()
  if self.old_pos then
    self.object:set_yaw(minetest.dir_to_yaw(vector.direction(pos, self.old_pos)))
  end
end

--slow down boat with friction
function pig:friction(self)
  local vel = self.object:get_velocity()
  vel = vector.multiply(vel,-1)
  vel = vector.divide(vel,100)
  if vel.y > 0 then
    self.object:add_velocity({x=vel.x,y=vel.y,z=vel.z})
  else
    self.object:add_velocity({x=vel.x,y=0,z=vel.z})
  end
end


--test if a node is water
function pig:testwater(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "water"))
end

--show pig got hurt
function pig:hurt(self,dtime)
  if self.hurt_cooldown > 0 then
    self.hurt_cooldown = self.hurt_cooldown - dtime
    self.particle_hurt = self.particle_hurt + dtime
    if self.particle_hurt >= 0.5 then
      self.particle_hurt = 0
      local pos = self.object:get_pos()
      heart_explosion(pos)
      minetest.sound_play(self.pig_sound, {
    		pos = pos,
    		max_hear_distance = 40,
    		gain = 2,
    		pitch = math.random(70,110)/100,
    	})
    end
  end
end

--when pig is punched
function pig:on_punch(puncher, time_from_last_punch, tool_capabilities, direction, damage)
  local newhp = self.object:get_hp()-damage
  local pos = self.object:get_pos()

  --if punch hurt pig
  if damage > 0 then
    --max out speed for longest time (freakout)
    self.speed_goal = 5
    self.timer = 0
    self.move_goal = 4
    self.hurt_cooldown = 4
    self.particle_hurt = 0

    heart_explosion(pos)

    minetest.sound_play(self.angry_pig_sound, {
  		pos = pos,
  		max_hear_distance = 40,
  		gain = 2,
  		pitch = math.random(70,110)/100,
  	})


    local item = minetest.add_item(pos, "items:bone")
    if item then
      item:get_luaentity().age = collection_age - 0.35
    end
  end
  if newhp == 0 then
    local item = minetest.add_item(self.object:get_pos(), "items:porkchop "..math.random(1,3))
    if item then
      item:get_luaentity().age = collection_age - 0.35
    end
  end
end

--save variables
function pig:get_staticdata()
    return minetest.write_json({
      rider = self.rider,
      timer = self.timer,
      move_goal = self.move_goal,
      speed_goal = self.speed_goal,
      yaw = self.yaw,
      turn_timer = self.turn_timer,
      turn_goal = self.turn_goal,
      turn_intensity = self.turn_intensity,
      turn_direction = self.turn_direction,
      jump_timer = self.jump_timer,
      oink_timer = self.oink_timer,
      oink_timer_goal = self.oink_timer_goal,
      hurt_cooldown = self.hurt_cooldown,
      particle_hurt = self.particle_hurt,
      hp = self.object:get_hp()
    })
end

minetest.register_entity("mob:pig", pig)



---debug items - could be used for spawn eggs
--debug item
minetest.register_craftitem("mob:pig", {
  description = "pig",
  inventory_image = "pig.png",
  liquids_pointable = true,
  on_place = function(itemstack, placer, pointed_thing)
    local pos = pointed_thing.above
    pos.y = pos.y + 0.5
    local test = minetest.add_entity(pos, "mob:pig")
    itemstack:take_item(1)
    return(itemstack)
  end,
})


--spawn mobs
local mob_spawn_timer = 0
local mob_spawn_goal = math.random(100,400) --set up small timer goal for initial mob spawning
minetest.register_globalstep(function(dtime)
  mob_spawn_timer = mob_spawn_timer + dtime
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 or not minetest.settings:get_bool("enable_damage") then
      if mob_spawn_timer >= mob_spawn_goal then
        mob_spawn_timer = 0
        mob_spawn_goal = math.random(100,400)
        local pos = player:get_pos()
        local node_group = minetest.find_nodes_in_area_under_air(vector.subtract(pos,20), vector.add(pos,20), {"nodes:grass"})
        if table.getn(node_group) > 0 then
          for i = 1,math.random(2,5) do --only spawn 2,5 mobs
            local new_pos = node_group[math.random(1,table.getn(node_group))]
            new_pos.y = new_pos.y + 1
            print("spawning pig at "..dump(new_pos))
            minetest.add_entity(new_pos,"mob:pig")
          end
        end
      end
    end
  end
end)
