--radius of rain
local rad = 10
--the timer that counts when to make more paricle spawners
local timer = 0

--this controls if the weather is clear, rain, or snow
local weather_change_timer = 0

--make weather change goal random
local weather_change_goal = math.random(200,400)

--make weather state random
weather = math.random(0,2) --0 clear 1 rain 2 snow

--we start the globalstep (each server tick)
minetest.register_globalstep(function(dtime)
  --add the timers
  timer = timer + dtime
  weather_change_timer = weather_change_timer + dtime


  --when it's time to change weather state
  --then reset everything
  if weather_change_timer > weather_change_goal then
    weather_change_goal = math.random(200,400)
    weather = math.random(0,2)
    print("weather changed to "..weather)
    weather_change_timer = 0
  end



  --when the timer hits 1 second we reset
  if timer >= 1 then
  --make this reset regardless to avoid a giant int consuming memory
  --on long term servers
  timer = 0

  --if the weather int is above clear do weather effects
  --or else pass to avoid cpu consumption
  if weather > 0 then
  --run through each player, getting their position
	for _,player in ipairs(minetest.get_connected_players()) do
    local pos = player:get_pos()
    --go through a x,y,z square (of the rad integer)
    for x = -rad,rad do
      for y = -rad,rad do
        for z = -rad,rad do

          --sprinkle in some randomness to balance the load
          if math.random() > 0.5 then

            --we vectorize x,y,z
            local newvec = vector.new(x,y,z)

            --check pos is the position we'll be checking and placing
            --the particle spawner if it is lit by the son
            local checkpos = vector.add(pos,newvec)

            --use the vector class to check the distance
            local distance = vector.distance(pos,checkpos)

            --if within distance proceed to the next step
            if distance < rad then

              --test if lit by the sun, then proceed to creating particle spawner
              local daylight = minetest.get_node_light(checkpos, 0.5)
              if daylight == 15 then

                --we use a particle spawner here for the sake of extreme randomness to mimic weather
                --only shown to the player's client to avoid confliction and mass lag
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
                elseif weather == 2 then
                  minetest.add_particlespawner({
                      amount = 1,
                      time = 2,
                      minpos = {x=checkpos.x-0.5, y=checkpos.y-0.5, z=checkpos.z-0.5},
                      maxpos = {x=checkpos.x+0.5, y=checkpos.y+0.5, z=checkpos.z+0.5},
                      minvel = {x=0, y=-1, z=0},
                      maxvel = {x=0, y=-3, z=0},
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

                      texture = "snow.png",

                      playername = player:get_player_name(),
                  })
                end
                end
              end
            end
          end
        end
      end
    end
  end
  end
end)
