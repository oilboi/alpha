minetest.register_on_newplayer(function(player)
  local pos = player:get_pos()
  minetest.add_item(pos, "boat:boat")
end)

local boat = {
  initial_properties = {
    physical = true, -- otherwise going uphill breaks
    visual = "mesh",
    collide_with_objects = true,
    collisionbox = {-0.49, -0.49, -0.49, 0.49, 0.49, 0.49},
    mesh = "boat.b3d",
	  textures = {"boat.png"},
	  visual_size = {x=3,y=3},
    timer = 0,
    speed = 0,
    automatic_face_movement_dir = 90.0,
    automatic_face_movement_max_rotation_per_sec = 65536, --65536
    rider = "",
  },
}
function boat:on_activate(staticdata, dtime_s)

    --self.object:set_acceleration({x=0,y=-10,z=0})

    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
        --restore old data
        if data then
          self.rider = data.rider
        end
    end
end

function boat:on_step(dtime)

  boat:friction(self)
  boat:float(self)
  boat:move(self)

  set_flow(self.object:get_pos(),self.object,7,-0.3)
  --boat:set_rotation(self)
  self.old_pos = self.object:get_pos()

end

--move with the rider
function boat:move(self)
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
      local dir = vector.divide(direction,5)
      self.object:add_velocity({x=dir.x,y=0,z=dir.z})
    end
  end
end

--makes the boat float
function boat:float(self)
  local pos = self.object:get_pos()
  local in_water =  boat:testwater(pos)

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



function boat:on_rightclick(clicker)
  local name = clicker:get_player_name()
  if self.rider == nil or self.rider == "" then
    self.rider = name
    clicker:set_attach(self.object, "", {x=0,y=0,z=0}, {x=0,y=0,z=0})
  elseif self.rider == name then
    self.rider = ""
    clicker:set_detach()
  end
end

function boat:set_rotation(self)
  local pos = self.object:get_pos()
  if self.old_pos then
    self.object:set_yaw(minetest.dir_to_yaw(vector.direction(pos, self.old_pos)))
  end
end

--slow down boat with friction
function boat:friction(self)
  local vel = self.object:get_velocity()
  vel = vector.multiply(vel,-1)
  vel = vector.divide(vel,30)
  if vel.y > 0 then
    self.object:add_velocity({x=vel.x,y=vel.y,z=vel.z})
  else
    self.object:add_velocity({x=vel.x,y=0,z=vel.z})
  end
end


--test if a node is water
function boat:testwater(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "water"))
end


function boat:on_punch(hitter)
  local item = minetest.add_item(self.object:get_pos(), "boat:boat")
  item:get_luaentity().age = collection_age - 0.35
  self.object:remove()
end

function boat:get_staticdata()
    return minetest.write_json({
      rider = self.rider,
    })
end

minetest.register_entity("boat:boat", boat)



minetest.register_craftitem("boat:boat", {
  description = "Boat",
  inventory_image = "boat_inv.png",
  liquids_pointable = true,
  on_place = function(itemstack, placer, pointed_thing)
    --don't add boat if not water
    if minetest.get_item_group(minetest.get_node(pointed_thing.under).name, "water") == 0 then return end

    local pos = pointed_thing.under
    pos.y = pos.y + 0.5
    local test = minetest.add_entity(pos, "boat:boat")
    itemstack:take_item(1)
    return(itemstack)
  end,
})
