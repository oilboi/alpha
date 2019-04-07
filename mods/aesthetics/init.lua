--make crazy particles
 minetest.register_on_dignode(function(pos, oldnode, digger)
   --find node texture information
   local node = oldnode.name
   local tile = minetest.registered_nodes[node].tiles

   mining_explosion(tile,pos,25,90,140,1,2)
end)

--tile is the tile table,pos,amount minimum, math.random(amount_max,amount_max2)
function mining_explosion(tile,pos,amount_min,amount_max,amount_max2,time_min,time_max)
  for i = amount_min,math.random(amount_max,amount_max2) do
    --select random part of the texture
    local texsizer = math.random(1,3)
    local size = texsizer/3 --the texture size affects the particle size for consistancy
    local texsize = {x=texsizer,y=texsizer}
    local texpos = {x=math.random(1,16-texsize.x)/64,y=math.random(1,16-texsize.y)/64}
    --filename1
    local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,table.getn(tile))]
    minetest.add_particle({
      pos = {x=pos.x+(math.random()*math.random(-1,1)/2),y=pos.y+(math.random()*math.random(-1,1)/2),z=pos.z+(math.random()*math.random(-1,1)/2)},
      velocity = {
      x=math.random()*math.random(-3,3),
      y=math.random(2,4),
      z=math.random()*math.random(-3,3)},
      acceleration = {x=0, y=-10, z=0},
      expirationtime = math.random(time_min,time_max)/2,
      size = size,
      collisiondetection = true,
      collision_removal = false,
      object_collision = true,
      vertical = false,
      texture = texture,
    })
  end
end
