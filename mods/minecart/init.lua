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
    --automatic_face_movement_dir = 90.0,
  },
}
function minecart:on_activate(staticdata, dtime_s)
    self.timer = 0
    self.speed = 0
    --in the future make this check for players around and they will "push it"
    self.object:set_acceleration({x=0,y=-10,z=0})

    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
    end
end

function minecart:on_step(dtime)
  --add_velocity(vel)
  minecart:repel(self)
  local vel = self.object:get_velocity()

  self.old_velocity = vel
end

--push away from players
function minecart:repel(self)
  local pos = self.object:getpos()
  local temp_pos = self.object:getpos()
  temp_pos.y = 0
  --magnet effect
  for _,object in ipairs(minetest.get_objects_inside_radius(pos, 1)) do
    if object:is_player() then
      local pos2 = object:getpos()
      local vec = vector.subtract(pos, pos2)
      vec = vector.divide(vec,3) --divide so the player doesn't fling the cart
      self.object:add_velocity({x=vec.x,y=0,z=vec.z})
    end
  end
end

function minecart:change_direction()

end


function minecart:on_punch(hitter)
  self.object:remove()
end

function minecart:get_staticdata()
    return minetest.write_json({
        message = self.message,
    })
end

minetest.register_entity("minecart:minecart", minecart)



minetest.register_craftitem("minecart:minecart", {
  description = "Minecart",
  inventory_image = "minecart.png",
  on_place = function(itemstack, placer, pointed_thing)
    print(dump(pointed_thing.under))
    minetest.add_entity(pointed_thing.under, "minecart:minecart")
  end,

})
