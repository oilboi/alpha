--the goal
--[[spawn weather entity checker to instantly fall to ground to find a column to spawn snow in
create table for snow to spawn
when player enters new node spawn new entities
create column of snow
repeat
when player goes out radius delete particlespawner


if weather_change_timer > weather_change_goal then
  weather_change_goal = math.random(200,400)
  weather = math.random(0,2)
  print("weather changed to "..weather)
  weather_change_timer = 0
end
]]

--radius of rain
local rad = 7
--the timer that counts when to make more paricle spawners
--local timer = 0

--this controls if the weather is clear, rain, or snow
--local weather_change_timer = 0
--make weather change goal random
--local weather_change_goal = 90000--math.random(200,400)

--make weather state random
--weather = 2--math.random(0,2) --0 clear 1 rain 2 snow


--local weather_radius = 10
--local weather_height = 10
--we start the globalstep (each server tick)
minetest.override_item("air",{
--on_construct = function(pos)
  --local timer = minetest.get_node_timer(pos)
  --if not timer:is_started() then
    --timer:start(math.random(25,300))
  --end
--end,
--when the sugarcane timer expires try to find water near, if not, reset timer
on_timer = function(pos, elapsed)

end,

})

local weather_table = {}
local weather_particle_table = {}
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
    --get center of node position
    local pos = vector.floor(vector.add(player:get_pos(),0.5))
    local name = player:get_player_name()

    local test_table = {}
    --build an environment map upside down
    if weather_table[name] and not vector.equals(pos,weather_table[name]) then
      --clear particle spawners
      if weather_particle_table[name] and table.getn(weather_particle_table[name]) > 0  then
        for _,id in ipairs(weather_particle_table[name]) do
          --print("delete old pas")
          minetest.delete_particlespawner(id)
        end
      end
      weather_particle_table[name] = {}


      for x = -rad,rad do
        test_table[x] = {}
        for z = -rad,rad do
          test_table[x][z] = {}
          --set a high point
          local high = pos.y+rad
          --try to get the lowest point
          for y = rad,-rad,-1 do
            local ipos = vector.add(pos,vector.new(x,y,z)) --index position
            local light = minetest.get_node_light(ipos, 0.5)
            if light == 15 then
              --set a new low if the point
              if pos.y+y < high then
                --print("new y is "..y)
                test_table[x][z] = pos.y + y
              end
            else
              break
            end
          end
        end
      end
    end

    if table.getn(test_table) > 0 then
      --generate new table for particlspawener ids
      if not weather_particle_table[name] then
        weather_particle_table[name] = {}
      end
      for x = -rad,rad do
        for z = -rad,rad do
          if test_table and test_table[x] and test_table[x][z] and type(test_table[x][z]) == "number" then
            --create particle columns
            --print("THE LOW FOR X "..x.." Z "..z.." IS: "..test_table[x][z])
            local id = minetest.add_particlespawner({
                amount = 5,
                time = 0,
                --minpos = {x=checkpos.x-0.5, y=checkpos.y-0.5, z=checkpos.z-0.5},
                minpos = {x=pos.x+x,y=test_table[x][z],z=pos.z+z},
                maxpos = {x=pos.x+x,y=pos.y+rad,z=pos.z+z},
                --maxpos = {x=checkpos.x+0.5, y=checkpos.y+0.5, z=checkpos.z+0.5},
                --minvel = {x=0, y=-1, z=0},
                --maxvel = {x=0, y=-3, z=0},
                minvel=vector.new(0,0,0),
                maxvel=vector.new(0,0,0),

                minacc = {x=0, y=0, z=0},
                maxacc = {x=0, y=0, z=0},
                minexptime = 0.25,
                maxexptime = 0.25,
                minsize = 3,
                maxsize = 3,

                collisiondetection = true,
                collision_removal = true,

                object_collision = true,

                vertical = true,

                texture = "heart.png",

                --playername = player:get_player_name(),
            })
            table.insert(weather_particle_table[name],id)
          end
        end
      end
    end
    --store the table
    weather_table[name] = pos

  end
end)


        --[[
        --go through the "roof" of the check
        for x = -rad,rad do
          for z = -rad,rad do
            for y = weather_height,-weather_height,-1 do




              --sprinkle in some randomness to balance the load
              --if math.random() > 0.9 then

              --we vectorize x,y,z
              local newvec = vector.new(x,y,z)

              --check pos is the position we'll be checking and placing
              --the particle spawner if it is lit by the son
              local checkpos = vector.add(pos,newvec)


              --test if lit by the sun, then proceed to creating particle spawner
              local daylight = minetest.get_node_light(checkpos, 0.5)
              if daylight == 15 then

                --we use a particle spawner here for the sake of extreme randomness to mimic weather
                --only shown to the player's client to avoid confliction and mass lag
                --rain
                if weather == 1 then
                  minetest.add_particlespawner({
                      amount = 1,
                      time = 1,
                      minpos = {x=checkpos.x-0.5, y=checkpos.y-0.5, z=checkpos.z-0.5},
                      maxpos = {x=checkpos.x+0.5, y=checkpos.y+0.5, z=checkpos.z+0.5},
                      minvel = {x=0, y=-25, z=0},
                      maxvel = {x=0, y=-25, z=0},
                      minacc = {x=0, y=0, z=0},
                      maxacc = {x=0, y=0, z=0},
                      minexptime = 1,
                      maxexptime = 1,
                      minsize = 2,
                      maxsize = 3,

                      collisiondetection = true,
                      collision_removal = true,

                      object_collision = true,

                      vertical = true,

                      texture = "rain.png",

                      playername = player:get_player_name(),
                  })
                --snow
                elseif weather == 2 then
                  minetest.add_particlespawner({
                      amount = 1,
                      time = 0.001,
                      --minpos = {x=checkpos.x-0.5, y=checkpos.y-0.5, z=checkpos.z-0.5},
                      minpos = checkpos,
                      maxpos = checkpos,
                      --maxpos = {x=checkpos.x+0.5, y=checkpos.y+0.5, z=checkpos.z+0.5},
                      --minvel = {x=0, y=-1, z=0},
                      --maxvel = {x=0, y=-3, z=0},
                      minvel=vector.new(0,0,0),
                      maxvel=vector.new(0,0,0),

                      minacc = {x=0, y=0, z=0},
                      maxacc = {x=0, y=0, z=0},
                      minexptime = 0.25,
                      maxexptime = 0.25,
                      minsize = 3,
                      maxsize = 3,

                      collisiondetection = true,
                      collision_removal = true,

                      object_collision = true,

                      vertical = true,

                      texture = "heart.png",

                      playername = player:get_player_name(),
                  })
                end
              else
                --print("breaking y")
                break
              end
            end
          end
        end
      end
    end

  end
end)
]]--
