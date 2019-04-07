 print("make particles go crazy on mine node")
--make crazy particles
 minetest.register_on_dignode(function(pos, oldnode, digger)
   --find node texture information
   local node = oldnode.name
   local tile = minetest.registered_nodes[node].tiles

   --select random part of the texture
   local texsizer = math.random(1,3)
   local size = texsizer/3 --the texture size affects the particle size for consistancy
   local texsize = {x=texsizer,y=texsizer}
   local texpos = {x=math.random(1,16-texsize.x)/64,y=math.random(1,16-texsize.y)/64}
   --filename1
   local texture = "[combine:"..texsize.x.."x"..texsize.y..":"..texpos.x..","..texpos.y.."="..tile[math.random(1,table.getn(tile))]

   for i = 25,math.random(50,70) do
   minetest.add_particle({
     pos = pos,
     velocity = {x=math.random(-2,2)+(math.random()*math.random(-1,1)), y=math.random(2,4)+(math.random()*math.random(-1,1)), z=math.random(-2,2)+(math.random()*math.random(-1,1))},
     acceleration = {x=0, y=-10, z=0},
     expirationtime = math.random(1,2),
     size = size,
     collisiondetection = true,
     collision_removal = false,
     object_collision = true,
     vertical = false,
     texture = texture,

   })
 end
end)
