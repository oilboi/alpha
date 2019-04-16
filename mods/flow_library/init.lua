
--returns param2 datas
local get_param2 = function(pos)
  return(minetest.get_node(pos).param2)
end

--check if liquid
local is_liquid = function(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "liquid") > 0)
end

--check if source
local is_source = function(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "source") > 0)
end

--check flowing around
local testflow = function(pos)
  if is_liquid(pos) == false then return(nil) end
  local newx = 0
  local newz = 0
  local high = get_param2(pos)
  for x = -1,1 do
    for z= -1,1 do
      local added_pos = {x=pos.x+x,y=pos.y,z=pos.z+z}
      if is_liquid(added_pos) == true then
        if is_source(added_pos) == false then
          --change to the highest param
          local new_param2 = get_param2(added_pos)
          print(new_param2)
          if new_param2 < high or new_param2 == 8 then --if y is changed, there's a drop
            newx = x
            newz = z
            high = new_param2
          end
        end
      end
    end
  end
  return({x=newx,y=0,z=newz})
end

--the main flow function
function set_flow(pos,object,divider)
  local direction = testflow(pos)
  if direction then
    object:add_velocity(vector.divide(direction,divider))
  end
end
