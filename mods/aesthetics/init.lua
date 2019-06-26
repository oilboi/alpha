--make crazy particles
 minetest.register_on_dignode(function(pos, oldnode, digger)
   if minetest.registered_nodes[oldnode.name] == nil then
     return
   end
   local tile = minetest.registered_nodes[oldnode.name].tiles
   mining_particle_explosion(tile,pos,15,0.5,1,10)
end)

--loops is how different the particles are
--amount is how many particles the particle spawner spawns
function mining_particle_explosion(tile,pos,amount,time_min,time_max,loops)
    local tablesize = table.getn(tile)
    for i = 1,loops do
      --select random part of the texture
      local texsizer = math.random(1,3)
      local size = texsizer/3 --the texture size affects the particle size for consistancy
      local texsize = {x=texsizer,y=texsizer}
      local texpos = {x=math.random(-16,-1-texsizer),y=math.random(-16,-1-texsizer)}

      --fix for animated textures
      local toop = tile[math.random(1,tablesize)]
      if tile[1].name then
        toop = tile[1].name
        tablesize = 1
      end

      local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..toop
      minetest.add_particlespawner({
          amount = amount,
          time = 0.01,
          minpos = {x=pos.x-0.5, y=pos.y-0.5, z=pos.z-0.5},
          maxpos = {x=pos.x+0.5, y=pos.y+0.5, z=pos.z+0.5},
          minvel = {x=-3, y=2, z=-3},
          maxvel = {x=3, y=4, z=3},
          minacc = {x=0, y=-10, z=0},
          maxacc = {x=0, y=-10, z=0},
          minexptime = time_min,
          maxexptime = time_max,
          minsize = size,
          maxsize = size+0.5,

          collisiondetection = true,
          collision_removal = true,

          object_collision = true,

          vertical = false,
          -- If true face player using y axis only
          texture = texture,
      })
    end
end


--turn tools into stick when dead and break sound with particles
function tool_break(itemstack, user, node, digparams)
  local oldstack = itemstack:get_name()
  itemstack:add_wear(digparams.wear)
  --if itemstack:get_wear() == 0 then --testing
  if itemstack:get_wear() == 0 and digparams.wear > 0 then
    minetest.sound_play("tool_break", {
      object = user,
      max_hear_distance = 30,
      gain = 1.0,
      pitch = math.random(70,100)/100,
    })

    --itemstack:replace("items:stick")
    local pos1 = user:get_pos()
    pos1.y = pos1.y + 1.5
    local tile = {minetest.registered_items[oldstack].inventory_image}
    tool_break_explosion(tile,pos1,25,1,2,10)
  end
  return(itemstack)
end

--loops is how different the particles are
--amount is how many particles the particle spawner spawns
function tool_break_explosion(tile,pos,amount,time_min,time_max,loops)
  for i = 1,loops do
    --select random part of the texture
    local texsizer = math.random(1,3)
    local size = texsizer/3 --the texture size affects the particle size for consistancy
    local texsize = {x=texsizer,y=texsizer}
    local texpos = {x=math.random(-16,-1-texsizer),y=math.random(-16,-1-texsizer)}
    --filename1
    local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,table.getn(tile))]
    minetest.add_particlespawner({
        amount = amount,
        time = 0.01,
        minpos = {x=pos.x-0.5, y=pos.y-0.5, z=pos.z-0.5},
        maxpos = {x=pos.x+0.5, y=pos.y+0.5, z=pos.z+0.5},
        minvel = {x=-3, y=2, z=-3},
        maxvel = {x=3, y=4, z=3},
        minacc = {x=0, y=-10, z=0},
        maxacc = {x=0, y=-10, z=0},
        minexptime = time_min,
        maxexptime = time_max,
        minsize = size,
        maxsize = size+0.5,

        collisiondetection = true,
        collision_removal = true,

        object_collision = true,

        vertical = false,
        -- If true face player using y axis only
        texture = texture,
    })
  end
end

--player hurt sound and particles
minetest.register_on_player_hpchange(function(player, hp_change, reason)
  if hp_change < 0 then
    minetest.sound_play("hurt", {
      object = player,
      max_hear_distance = 30,
      gain = 1.0,
      pitch = math.random(80,100)/100,
    })
    local pos = player:get_pos()
    pos.y = pos.y + 1.5
    heart_explosion(pos)
  end
end)

function heart_explosion(pos)
  minetest.add_particlespawner({
      amount = 100,
      time = 0.01,
      minpos = {x=pos.x-0.5, y=pos.y-0.5, z=pos.z-0.5},
      maxpos = {x=pos.x+0.5, y=pos.y+0.5, z=pos.z+0.5},
      minvel = {x=-3, y=2, z=-3},
      maxvel = {x=3, y=4, z=3},
      minacc = {x=0, y=-10, z=0},
      maxacc = {x=0, y=-10, z=0},
      minexptime = time_min,
      maxexptime = time_max,
      minsize = 1,
      maxsize = 3,

      collisiondetection = true,
      collision_removal = true,

      object_collision = true,

      vertical = false,
      -- If true face player using y axis only
      texture = "heart.png",
      --attached = player,
  })
end
--------------------------------

--torch flame and smoke
local function torch_flame_and_smoke(pos,node)
  pos.y = pos.y + 0.2
  --do fixes for flame and smoke position
  if node.param2 > 1 then
    local modifier = vector.divide(minetest.wallmounted_to_dir(node.param2),5)
    --print(dump(modifier))
    pos = vector.add(pos,modifier)
  elseif node.param2 == 0 then
    pos.y = pos.y - 0.3
  end

  minetest.add_particlespawner({
      amount = 1,
      time = 0.001,
      minpos = pos,
      maxpos = pos,
      minvel = {x=0, y=0, z=0},
      maxvel = {x=0, y=0, z=0},
      minacc = {x=0, y=0, z=0},
      maxacc = {x=0, y=0, z=0},
      minexptime = 1,
      maxexptime = 1,
      minsize = 3,
      maxsize = 5,
      collisiondetection = false,
      collision_removal = false,
      object_collision = false,

      vertical = false,
      -- If true face player using y axis only
      texture = "flame.png",
  })
  minetest.add_particlespawner({
      amount = 10,
      time = 1,
      minpos = pos,
      maxpos = pos,
      minvel = {x=-0.1, y=0.1, z=-0.1},
      maxvel = {x=0.1, y=0.3, z=0.1},
      minacc = {x=-0.5, y=0.5, z=-0.5},
      maxacc = {x=0.5, y=1, z=0.5},
      minexptime = 0.5,
      maxexptime = 1.5,
      minsize = 1,
      maxsize = 2.5,

      collisiondetection = true,
      collision_removal = false,

      object_collision = true,

      vertical = false,
      -- If true face player using y axis only
      texture = "puff.png",
  })
end

minetest.register_abm({
  label = "torch flame",
	nodenames = {"torch:torch_wall","torch:torch"},
	interval = 1,
	chance = 1,
	action = function(pos,node)
    torch_flame_and_smoke(pos,node)
	end,
})

------

--stuff to do when a player joins the game
minetest.register_on_joinplayer(function(player)
  local version_info = player:hud_add({
       hud_elem_type = "text",
       position      = {x = 0, y = 1},
       offset        = {x = 70,   y = -10},
       text          = "Alpha Version 0.03",
       alignment     = {x = 0, y = 0},  -- center aligned
       scale         = {x = 1000, y = 1000}, -- covered later
        number    = 0xFFFFFF,
  })
end)
