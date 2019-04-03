local minecart = {
  initial_properties = {
    physical = false, -- otherwise going uphill breaks
    collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    visual = "mesh",
    mesh = "minecart.b3d",
    visual_size = {x=1, y=1},
    textures = {"minecart_ent.png"},
  },
}
function minecart:on_activate(staticdata, dtime_s)
    self.timer = 0
    self.speed = 0
    if staticdata ~= "" and staticdata ~= nil then
        local data = minetest.parse_json(staticdata) or {}
    end
end

function minecart:on_step(dtime)
    if self.speed < 3 then
      self.speed = self.speed + (dtime/4)
    end
    self.timer = self.timer + dtime



    --test something
    self.timer = 0
    local pos      = self.object:get_pos()
    local pos_down = vector.subtract(pos, vector.new(0, 1, 0))

    local delta


    if minetest.get_node(pos_down).name == "air" then
        delta = vector.new(0, -1, 0)
    elseif minetest.get_node(pos).name == "air" then
        delta = vector.new(0, 0, 1)
    else
        delta = vector.new(0, 1, 0)
    end

    delta = vector.multiply(delta, self.speed)

    self.object:move_to(vector.add(pos, delta))
end

function minecart:change_direction()
    --self.message = msg
end


function minecart:on_punch(hitter)

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
    print(dump(pointed_thing.above))
    minetest.add_entity(pointed_thing.above, "minecart:minecart")
  end,

})
