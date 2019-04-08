local output,_ = minetest.get_craft_result({ method = "cooking", width = 1, items = {ItemStack("nodes:coal")}})
print(dump(output.item:get_name()))

minetest.register_node("furnace:furnace", {
	description = "Furnace",
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
	tiles = {
		"furnace.png",
	},
  node_box = {
    type = "fixed",
    fixed = {
      {0.3, -0.5, -0.5, 0.5, 0.5, 0.5},--left
      {-0.5, -0.5, -0.5, -0.3, 0.5, 0.5},--right
      {-0.5, -0.5, 0.3, 0.5, 0.5, 0.5},--front
      {-0.5, -0.5, -0.5, 0.5, 0.5, -0.3},--back
      {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},--bottom
    },
  },
  selection_box = {
          type = "fixed",
          fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
  },
  groups = {stone = 1,furnace=1},
  sounds = sounds.stone(),
})
minetest.register_node("furnace:furnace_lit", {
	description = "Furnace",
  drawtype = "nodebox",
  paramtype = "light",
  paramtype2 = "facedir",
  drop = "furnace:furnace",
	tiles = {
		"furnace.png",
	},
  node_box = {
    type = "fixed",
    fixed = {
      {0.3, -0.5, -0.5, 0.5, 0.5, 0.5},--left
      {-0.5, -0.5, -0.5, -0.3, 0.5, 0.5},--right
      {-0.5, -0.5, 0.3, 0.5, 0.5, 0.5},--front
      {-0.5, -0.5, -0.5, 0.5, 0.5, -0.3},--back
      {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},--bottom
    },
  },
  selection_box = {
          type = "fixed",
          fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
  },
  groups = {stone = 1,furnace=1},
  sounds = sounds.stone(),
})


minetest.register_abm({
  label = "furnace activator",
	nodenames = {"furnace:furnace"},
	interval = 1,
	chance = 1,
	action = function(pos)
    for _,object in ipairs(minetest.get_objects_inside_radius(pos, 3)) do
      if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
        local pos2 = object:getpos()
        local vec = vector.subtract(pos,pos2)
        if math.abs(vec.x) <= 0.5 and math.abs(vec.z) <= 0.5 then --this would allow players to throw items up at the furnace - fix later
          if minetest.get_item_group(object:get_luaentity().itemstring, "flammable") > 0 then
            --object:get_luaentity().age = 0 -- reset age to cook
            minetest.set_node(pos,{name="furnace:furnace_lit"})
            local meta = minetest.get_meta(pos)
            local level = minetest.get_item_group(object:get_luaentity().itemstring, "flammable") * 40 -- set the timer
            meta:set_int("timer", level)
            object:remove()
          end
        end
      end
    end
	end,
})


minetest.register_abm({
  label = "furnace lit",
	nodenames = {"furnace:furnace_lit"},
	interval = 1,
	chance = 1,
	action = function(pos)
    minetest.add_particlespawner({
        amount = 50,
        time = 1,
        minpos = {x=pos.x-0.3, y=pos.y-0.3, z=pos.z-0.3},
        maxpos = {x=pos.x+0.3, y=pos.y+0.5, z=pos.z+0.3},
        minvel = {x=-0.3, y=0.3, z=-0.3},
        maxvel = {x=0.3, y=1, z=0.3},
        minacc = {x=-1, y=1, z=-1},
        maxacc = {x=1, y=3, z=1},
        minexptime = 2,
        maxexptime = 4,
        minsize = 1,
        maxsize = 2.5,

        collisiondetection = true,
        collision_removal = false,

        object_collision = true,

        vertical = false,
        -- If true face player using y axis only
        texture = "puff.png",
    })
    for _,object in ipairs(minetest.get_objects_inside_radius(pos, 3)) do
      if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
        local pos2 = object:getpos()
        local vec = vector.subtract(pos,pos2)
        local flammable = minetest.get_item_group(object:get_luaentity().itemstring, "flammable")
        local stack = object:get_luaentity().itemstring
        if math.abs(vec.x) <= 0.5 and math.abs(vec.z) <= 0.5 and flammable > 0 then --this would allow players to throw items up at the furnace - fix later
            --object:get_luaentity().age = 0 -- reset age to cook
            local meta = minetest.get_meta(pos)
            local level = flammable * 40 -- set the timer
            meta:set_int("timer", level)
            object:remove()

        elseif math.abs(vec.x) <= 0.5 and math.abs(vec.z) <= 0.5 and  minetest.get_craft_result({ method = "cooking", width = 1, items = {ItemStack(stack)}}) ~= nil then
          local output,_ = minetest.get_craft_result({ method = "cooking", width = 1, items = {ItemStack(stack)}})
          if output.item:get_name() ~= "" then
            object:remove()
            local p = table.copy(pos)
            p.y = p.y + 0.5
            local newobj = minetest.add_item(p,output.item:get_name())
            newobj:get_luaentity().age = collection_age - 0.25
            newobj:set_velocity({x=math.random(-3,3),y=math.random(3,6),z=math.random(-3,3)})
            minetest.sound_play("hiss", {
              pos = p,
              max_hear_distance = 16,
              gain = 1.0,
              pitch = math.random(60,120)/100,
            })
          end

        else
          local meta = minetest.get_meta(pos)
          local time = meta:get_int("timer", level)
          time = time - 1
          --count down furnace timer
          --print(time)
          if time > 0 then
            meta:set_int("timer",time)
          else --when done make back to regular furnace
            minetest.set_node(pos,{name="furnace:furnace"})
          end
        end
      end
    end
	end,
})
