minetest.register_on_joinplayer(function(player)
  local pos = player:getpos()
  minetest.add_item(pos, "nodes:rail_straight 99")
  minetest.add_item(pos, "nodes:rail_turn 99")
  minetest.add_item(pos, "minecart:minecart 99")
end)

--potential: minecarts pushing minecarts, minecart trains, furnace minecart
local minecart = {
  initial_properties = {
    physical = true, -- otherwise going uphill breaks
    collide_with_objects = false,
    collisionbox = {-0.29, -0.7, -0.29, 0.29, 0.5, 0.29},
    visual = "mesh",
    mesh = "minecart.b3d",
    visual_size = {x=1, y=1},
    textures = {"minecart_ent.png"},
    timer = 0,
    speed = 0,
    yaw = 0,
    automatic_face_movement_dir = 0.0,
    automatic_face_movement_max_rotation_per_sec = -1,
    furnace = false,
  },

}
function minecart:on_activate(staticdata, dtime_s)

    self.object:set_acceleration({x=0,y=-10,z=0})
    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
        --restore old data
        if data then
          self.timer = data.timer
          self.speed = data.speed
          self.old_velocity = data.old_velocity
          self.old_pos = data.old_pos
          self.furnace = data.furnace
        end
    end
end

function minecart:on_step(dtime)
  minecart:repel(self)
  minecart:change_direction(self,dtime)
  minecart:furnace_minecart(self)
  minecart:friction(self)
  local vel = self.object:get_velocity()
  minecart:set_rotation(self)

  self.old_velocity = vel
  self.old_pos = self.object:getpos()
end

--test out furnace minecart mechanics
function minecart:furnace_minecart(self)
  if self.furnace == true then
    local pos = self.object:getpos()
    minetest.add_particle({
    	pos = pos,
    	velocity = {x=0, y=math.random(2,4), z=0},
    	acceleration = {x=math.random(-1,1), y=math.random(2,4), z=math.random(-1,1)},
    	expirationtime = math.random(2,5),
    	size = math.random(1,3),
    	collisiondetection = false,
    	vertical = false,
    	texture = "puff.png",
    })
    local vel = self.object:get_velocity()
    --limit the speed
    if math.abs(vel.x) < 3 and math.abs(vel.z) < 3 then
      self.object:add_velocity(vel)
    end
  end
end
--test out furnace minecart
function minecart:on_rightclick(clicker)
  print(self.furnace)
  if self.furnace == false or self.furnace == nil then
    self.furnace = true
  else
    self.furnace = false
  end
end

function minecart:set_rotation(self)
  local pos = self.object:getpos()
  if self.old_pos then
    self.object:set_yaw(minetest.dir_to_yaw(vector.direction(pos, self.old_pos)))
  end
end

--slow down cart with friction
function minecart:friction(self)
  local vel = self.object:getvelocity()
  vel = vector.multiply(vel,-1)
  vel = vector.divide(vel,100)
  self.object:add_velocity(vel)
end

--push away from players
function minecart:repel(self)
  local pos = self.object:getpos()
  local temp_pos = self.object:getpos()
  temp_pos.y = 0
  --magnet effect
  for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
    if object:is_player() or (object:get_luaentity() and object:get_luaentity().name == "minecart:minecart") then
      local pos2 = object:getpos()
      local vec = vector.subtract(pos, pos2)
      --vec = vector.divide(vec,1.5)
      --vec = vector.normalize(vec)
      --vec = vector.divide(vec,2) --divide so the player doesn't fling the cart
      self.object:add_velocity({x=vec.x,y=0,z=vec.z})
    end
  end
end
--turn corners on rails
function minecart:change_direction(self,dtime)
  local vel = self.object:get_velocity()
  local pos = self.object:getpos()

  local old = self.old_velocity
  --change direction on rail
  if old then
    --print("what")
  if (math.abs(old.x) > math.abs(old.z) and vel.x == 0) then
    if minecart:testrail({x=pos.x,y=pos.y,z=pos.z+1}) ~= 0 then
      self.object:add_velocity({x=0,y=old.y,z=math.abs(old.x)})
    elseif minecart:testrail({x=pos.x,y=pos.y,z=pos.z-1}) ~= 0 then
      self.object:add_velocity({x=0,y=old.y,z=math.abs(old.x)*-1})
    end
  elseif (math.abs(old.z) > math.abs(old.x) and vel.z == 0)  then
    if minecart:testrail({x=pos.x+1,y=pos.y,z=pos.z}) ~= 0 then
      self.object:add_velocity({x=math.abs(old.z),y=old.y,z=0})
    elseif minecart:testrail({x=pos.x-1,y=pos.y,z=pos.z}) ~= 0 then
      self.object:add_velocity({x=math.abs(old.z)*-1,y=old.y,z=0})
    end
  end
  end
end


--test if a node is rail
function minecart:testrail(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "rail"))
end


function minecart:on_punch(hitter)
  self.object:remove()
end

function minecart:get_staticdata()
    return minetest.write_json({
        message = self.message,
        timer   = self.timer,
        speed   = self.speed,
        old_velocity = self.old_velocity,
        old_pos = self.old_pos,
        furnace = self.furnace,
    })
end

minetest.register_entity("minecart:minecart", minecart)



minetest.register_craftitem("minecart:minecart", {
  description = "Minecart",
  inventory_image = "minecart.png",
  on_place = function(itemstack, placer, pointed_thing)
    print(dump(pointed_thing.above))
    minetest.add_entity(pointed_thing.above, "minecart:minecart")
  end,

})
