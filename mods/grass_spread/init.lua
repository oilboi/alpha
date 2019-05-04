--gets called when grass spread timer ends
function dirt_on_timer(pos)

  --if can't find dirt cancel
	if not minetest.find_node_near(pos, 1, "nodes:grass") then
		return false
	end

  --don't spread if node is not in sunlight
  local check_above_pos = table.copy(pos)
  check_above_pos.y = check_above_pos.y+1
  if minetest.get_node_light(check_above_pos, 0.5) ~= 15 then
    return false
  end


	local node = minetest.get_node(pos)

	minetest.set_node(pos,{name="nodes:grass"})
	local tile = minetest.registered_nodes["nodes:grass"].tiles
	mining_particle_explosion(tile,pos,20,0.5,1.5,1)
end

--starts grass timer on place
function dirt_on_place(pos)
  local node = minetest.get_node(pos)
  local timer = minetest.get_node_timer(pos)
  if not timer:is_started() then
    timer:start(math.random())--(math.random(200, 400))
  end
end

--starts spreads grass on construct and destruct
function grass_after_destruct(pos)
	for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, 1),vector.add(pos, 1), "nodes:dirt")) do
		local node = minetest.get_node(v)
		local timer = minetest.get_node_timer(v)
		if node.param2 == 0 and not timer:is_started() then
			timer:start(math.random())--(math.random(20, 120) / 10)
		end
	end
end
