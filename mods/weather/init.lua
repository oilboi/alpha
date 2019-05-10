--the goal
--[[spawn weather entity checker to instantly fall to ground to find a column to spawn snow in
create table for snow to spawn
when player enters new node spawn new entities
create column of snow
repeat
when player goes out radius delete particlespawner



]]

--radius of rain
local rad = 7

weather = 2


local weather_table = {}
local weather_particle_table = {}
local weather_timer = 0
local update_timer = 0.25
local weather_change_timer = 0
local weather_change_goal = math.random(200,400)
minetest.register_globalstep(function(dtime)

  if weather == 0 then return end

  weather_timer = weather_timer + dtime
  local update_weather = false
  if weather_timer > update_timer then
    weather_timer = 0
    update_weather = true
  end
  weather_change_timer = weather_change_timer + dtime
  if weather_change_timer > weather_change_goal then
    weather_change_goal = math.random(200,400)
    weather = math.random(0,2)
    print("weather changed to "..weather)
    weather_change_timer = 0
  end

	for _,player in ipairs(minetest.get_connected_players()) do
    --get center of node position
    local pos = vector.floor(vector.add(player:get_pos(),0.5))
    local name = player:get_player_name()

    local test_table = {}
    --build an environment map upside down
    if update_weather == true then --or (weather_table[name] and not vector.equals(pos,weather_table[name])) then
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
            local id
            if weather == 1 then
              id = minetest.add_particlespawner({
                  amount = 1,
                  time = 0,
                  minpos = {x=pos.x+x-0.5,y=test_table[x][z],z=pos.z+z-0.5},
                  maxpos = {x=pos.x+x+0.5,y=pos.y+rad,z=pos.z+z+0.5},
                  minvel = {x=0, y=-25, z=0},
                  maxvel = {x=0, y=-25, z=0},
                  minacc = {x=0, y=0, z=0},
                  maxacc = {x=0, y=0, z=0},
                  minexptime = 1,
                  maxexptime = 1,
                  minsize = 4,
                  maxsize = 6,

                  collisiondetection = true,
                  collision_removal = true,

                  object_collision = true,

                  vertical = true,

                  texture = "rain.png",

                  playername = name,
              })
            elseif weather == 2 then
              id = minetest.add_particlespawner({
                  time = 0,
                  amount = 1,
                  minpos = {x=pos.x+x-0.5,y=test_table[x][z],z=pos.z+z-0.5},
                  maxpos = {x=pos.x+x+0.5,y=pos.y+rad,z=pos.z+z+0.5},
                  minvel = {x=0, y=-1, z=0},
                  maxvel = {x=0, y=-3, z=0},

                  minacc = {x=-1, y=0, z=-1},
                  maxacc = {x=1, y=0, z=1},
                  minexptime = 1,
                  maxexptime = 2,
                  minsize = 2,
                  maxsize = 3,

                  collisiondetection = true,
                  collision_removal = true,

                  object_collision = true,

                  vertical = true,

                  texture = "snow.png",

                  playername = name,
              })
            end
            table.insert(weather_particle_table[name],id)
          end
        end
      end
    end
    --store the table
    weather_table[name] = pos

  end
end)

--a hook for other mods to use
function delete_weather_particle_spawners()
  --delete particle spawners
  for _,player in ipairs(minetest.get_connected_players()) do
    local name = player:get_player_name()

    if weather_particle_table[name] and table.getn(weather_particle_table[name]) > 0  then
      for _,id in ipairs(weather_particle_table[name]) do
        minetest.delete_particlespawner(id)
      end
    end
    weather_particle_table[name] = {}
  end
end
