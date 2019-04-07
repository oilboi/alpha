--make crazy particles
 minetest.register_on_dignode(function(pos, oldnode, digger)
   --find node texture information
   local node = oldnode.name
   local tile = minetest.registered_nodes[node].tiles

   mining_particle_explosion(tile,pos,25,50,70,1,2)
end)

--tile is the tile table,pos,amount minimum, math.random(amount_max,amount_max2)
function mining_particle_explosion(tile,pos,amount_min,amount_max,amount_max2,time_min,time_max)
  for i = amount_min,math.random(amount_max,amount_max2) do
    --select random part of the texture
    local texsizer = math.random(1,3)
    local size = texsizer/3 --the texture size affects the particle size for consistancy
    local texsize = {x=texsizer,y=texsizer}
    local texpos = {x=math.random(-16,-1-texsizer),y=math.random(-16,-1-texsizer)}
    --filename1
    local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,table.getn(tile))]
    minetest.add_particle({
      pos = {x=pos.x+(math.random()*math.random(-1,1)/2),y=pos.y+(math.random()*math.random(-1,1)/2),z=pos.z+(math.random()*math.random(-1,1)/2)},
      velocity = {
      x=math.random()*math.random(-3,3),
      y=math.random(2,4),
      z=math.random()*math.random(-3,3)},
      acceleration = {x=0, y=-10, z=0},
      expirationtime = (math.random(time_min,time_max)+math.random())/2,
      size = size,
      collisiondetection = true,
      collision_removal = false,
      object_collision = true,
      vertical = false,
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
    tool_break_explosion(tile,pos1,90,150,170,1,2,user:get_look_dir())
  end
  return(itemstack)
end

--tile is the tile table,pos,amount minimum, math.random(amount_max,amount_max2)
function tool_break_explosion(tile,pos,amount_min,amount_max,amount_max2,time_min,time_max,dir)
  for i = amount_min,math.random(amount_max,amount_max2) do
    --select random part of the texture
    local texsizer = math.random(1,3)
    local size = texsizer/3 --the texture size affects the particle size for consistancy
    local texsize = {x=texsizer,y=texsizer}
    local texpos = {x=math.random(-16,-1-texsizer),y=math.random(-16,-1-texsizer)}
    --filename1
    local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,table.getn(tile))]
    minetest.add_particle({
      pos = {x=pos.x+(math.random()*math.random(-1,1)/2),y=pos.y+(math.random()*math.random(-1,1)/2),z=pos.z+(math.random()*math.random(-1,1)/2)},
      velocity = {
      x=dir.x*2,
      y=dir.y*4,
      z=dir.z*2},
      acceleration = {x=0, y=-10, z=0},
      expirationtime = (math.random(time_min,time_max)+math.random())/6,
      size = size,
      collisiondetection = true,
      collision_removal = false,
      object_collision = true,
      vertical = false,
      texture = texture,
    })
  end
end

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
