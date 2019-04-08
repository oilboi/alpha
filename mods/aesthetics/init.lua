--make crazy particles
 minetest.register_on_dignode(function(pos, oldnode, digger)
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

      local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,tablesize)]
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
      pos = user:getpos(),
      max_hear_distance = 100,
      gain = 1.0,
    })

    --itemstack:replace("items:stick")
    local pos1 = user:getpos()
    pos1.y = pos1.y + 1.5
    local tile = {minetest.registered_items[oldstack].wield_image}
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

--player hurt sound
minetest.register_on_player_hpchange(function(player, hp_change, reason)
  if hp_change < 0 then
    minetest.sound_play("hurt", {
      pos = player:getpos(),
      max_hear_distance = 100,
      gain = 1.0,
      pitch = math.random(80,100)/100,
    })
  end
end)
