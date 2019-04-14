minetest.register_on_newplayer(function(player)
  local pos = player:get_pos()
  minetest.add_item(pos, "nodes:rail_straight 99")
  minetest.add_item(pos, "nodes:rail_turn 99")
  minetest.add_item(pos, "minecart:minecart 99")
end)

--potential: minecarts pushing minecarts, minecart trains, furnace minecart
local minecart = {
  initial_properties = {
    physical = true, -- otherwise going uphill breaks
    collide_with_objects = true,
    collisionbox = {-0.295, -1, -0.295, 0.295, 0.5, 0.295},
    visual = "mesh",
    mesh = "minecart.b3d",
    visual_size = {x=1, y=1},
    textures = {"minecart_ent.png"},
    timer = 0,
    speed = 0,
    yaw = 0,
    automatic_face_movement_dir = 90.0,
    automatic_face_movement_max_rotation_per_sec = 10,
    furnace = false,
    axis = "z",
    stepheight = 8/16, --1 pixel height to go up hill
  },

}
function minecart:on_activate(staticdata, dtime_s)
    if self.axis == nil then
      self.axis = "z"
    end
    if self.timer == nil then
      self.timer = 0
    end

    self.object:set_acceleration({x=0,y=-20,z=0})
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
  self.timer = self.timer + dtime

  minecart:repel(self)
  minecart:change_direction(self,dtime)
  minecart:furnace_minecart(self)
  minecart:friction(self)
  local vel = self.object:get_velocity()
  minecart:set_rotation(self)
  minecart:set_axis(self) -- make sure this is last
  self.old_velocity = vel
  self.old_pos = self.object:get_pos()
end

function minecart:set_axis(self)
  local vel = self.object:get_velocity()
  if math.abs(vel.x) > math.abs(vel.z) then
    self.axis = "x"
  else
    self.axis = "z"
  end
end

--test out furnace minecart mechanics
function minecart:furnace_minecart(self)
  if self.furnace == true then
    local pos = self.object:get_pos()
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
    local speed_limit = 2
    if math.abs(vel.x) < speed_limit and math.abs(vel.z) < speed_limit then
      self.object:add_velocity(vector.divide(vel,5))
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
  local pos = self.object:get_pos()
  if self.old_pos then
    self.object:set_yaw(minetest.dir_to_yaw(vector.direction(pos, self.old_pos)))
  end
end

--slow down cart with friction
function minecart:friction(self)
  local vel = self.object:getvelocity()
  vel = vector.multiply(vel,-1)
  vel = vector.divide(vel,100)
  self.object:add_velocity({x=vel.x,y=-5,z=vel.z})
end

--push away from players
function minecart:repel(self)
  local pos = self.object:get_pos()
  local temp_pos = self.object:get_pos()
  temp_pos.y = 0
  --magnet effect
  for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
    --change wether powered or not
    --basically if true, the minecart will only repel to players
    if self.furnace == false or self.furnace == nil then
      if object:is_player() or (object:get_luaentity() and object:get_luaentity().name == "minecart:minecart" and object ~= self.object) then
        local pos2 = object:get_pos()
        local vec = vector.subtract(pos, pos2)
        --the closer in the more it repels
        vec = vector.multiply(vec,(vector.distance(pos, pos2)))
        --follow the current rail
        local x = 0
        local z = 0
        if self.axis == "x" then
          x = vec.x
        elseif self.axis == "z" then
          z = vec.z
        end
        self.object:add_velocity({x=x,y=-5,z=z})
      end
    elseif self.furnace == true then
      if object:is_player() then
        local pos2 = object:get_pos()
        local vec = vector.subtract(pos, pos2)
        --the closer in the more it repels
        local multiplier = 2
        vec = vector.multiply(vec,(vector.distance(pos, pos2)))
        --follow the current rail
        local x = 0
        local z = 0
        if self.axis == "x" then
          x = vec.x
        elseif self.axis == "z" then
          z = vec.z
        end
        self.object:add_velocity({x=x,y=-5,z=z})
      end
    end
  end
end
--turn corners on rails
function minecart:change_direction(self,dtime)
  --a cooldown for turn spamming
  if self.timer < 0 then
    --print("test "..self.timer)
    return
  end

  local vel = self.object:get_velocity()
  local pos = self.object:get_pos()
  pos.y = pos.y - 0.75

  local old = self.old_velocity
  --change direction on rail
  if old then
    --print("what")
  if self.axis == "x" and math.floor(math.abs(vel.x)) == 0 then
    --print("axis X repeat test")
    --if (old.x > 0 and minetest.get_node({x=pos.x+0.52,y=pos.y,z=pos.z}).name == "air") or (old.x < 0 and minetest.get_node({x=pos.x-0.52,y=pos.y,z=pos.z}).name == "air") then
      if minecart:testrail({x=pos.x,y=pos.y,z=pos.z+0.52}) ~= 0 then
        self.object:add_velocity({x=0,y=-5,z=math.abs(old.x)})
        self.timer = 0
      elseif minecart:testrail({x=pos.x,y=pos.y,z=pos.z-0.52}) ~= 0 then
        self.object:add_velocity({x=0,y=-5,z=math.abs(old.x)*-1})
        self.timer = 0
      end
    --end
  elseif self.axis == "z" and math.floor(math.abs(vel.z)) == 0  then
    --print("axis Z repeat test")
    if minecart:testrail({x=pos.x+0.52,y=pos.y,z=pos.z}) ~= 0 then
      self.object:add_velocity({x=math.abs(old.z),y=-5,z=0})
      self.timer = 0
    elseif minecart:testrail({x=pos.x-0.52,y=pos.y,z=pos.z}) ~= 0 then
      self.object:add_velocity({x=math.abs(old.z)*-1,y=-5,z=0})
      self.timer = 0
    end
  end
  end
  self.old_axis = self.axis
end


--test if a node is rail
function minecart:testrail(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "rail"))
end


function minecart:on_punch(hitter)
  local item = minetest.add_item(self.object:get_pos(), "minecart:minecart")
  item:get_luaentity().age = collection_age - 0.35
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
    local pos = pointed_thing.above
    pos.y = pos.y + 1
    local test = minetest.add_entity(pos, "minecart:minecart")
    itemstack:take_item(1)
    return(itemstack)
  end,
})
