
function leafdecay_on_timer(pos)
	if minetest.find_node_near(pos, 2, "nodes:tree") then
		return false
	end

	local node = minetest.get_node(pos)
	local drops = minetest.get_node_drops(node.name)
  --local droppy = drops[1]
	for _, item in ipairs(drops) do

    if math.random() > 0.98 then
			minetest.add_item({
				x = pos.x - 0.5 + math.random(),
				y = pos.y - 0.5 + math.random(),
				z = pos.z - 0.5 + math.random(),
			}, item)
    end
	end

	minetest.remove_node(pos)
	--minetest.check_for_falling(pos)
end


function leafdecay_after_destruct(pos, oldnode)
	for _, v in pairs(minetest.find_nodes_in_area(vector.subtract(pos, 2),
			vector.add(pos, 2), "nodes:leaves")) do
		local node = minetest.get_node(v)
		local timer = minetest.get_node_timer(v)
		if node.param2 == 0 and not timer:is_started() then
			timer:start(0)--(math.random(20, 120) / 10)
		end
	end
end
