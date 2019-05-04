flowlib = {}

--sum of direction vectors must match an array index
local function to_unit_vector(dir_vector)
	--(sum,root)
	-- (0,1), (1,1+0=1), (2,1+1=2), (3,1+2^2=5), (4,2^2+2^2=8)
	local inv_roots = {[0] = 1, [1] = 1, [2] = 0.70710678118655, [4] = 0.5
		, [5] = 0.44721359549996, [8] = 0.35355339059327}
	local sum = dir_vector.x*dir_vector.x + dir_vector.z*dir_vector.z
	return {x=dir_vector.x*inv_roots[sum],y=dir_vector.y
		,z=dir_vector.z*inv_roots[sum]}
end

local is_touching = function(realpos,nodepos,radius)
	local boarder = 0.5 - radius
	return (math.abs(realpos - nodepos) > (boarder))
end

flowlib.is_touching = is_touching

local is_water = function(pos)
	return (minetest.get_item_group(minetest.get_node(
			{x=pos.x,y=pos.y,z=pos.z}).name
		, "water") ~= 0)
end

flowlib.is_water = is_water

local node_is_water = function(node)
	return (minetest.get_item_group(node.name, "water") ~= 0)
end

flowlib.node_is_water = node_is_water

local is_lava = function(pos)
	return (minetest.get_item_group(minetest.get_node(
			{x=pos.x,y=pos.y,z=pos.z}).name
		, "lava") ~= 0)
end

flowlib.is_lava = is_lava

local node_is_lava = function(node)
	return (minetest.get_item_group(node.name, "lava") ~= 0)
end

flowlib.node_is_lava = node_is_lava


local is_liquid = function(pos)
	return (minetest.get_item_group(minetest.get_node(
			{x=pos.x,y=pos.y,z=pos.z}).name
		, "liquid") ~= 0)
end

flowlib.is_liquid = is_liquid

local node_is_liquid = function(node)
	return (minetest.get_item_group(node.name, "liquid") ~= 0)
end

flowlib.node_is_liquid = node_is_liquid

--This code is more efficient
local function quick_flow_logic(node,pos_testing,direction)
	local name = node.name
	if not minetest.registered_nodes[name] then
		return 0
	end
	if minetest.registered_nodes[name].liquidtype == "source" then
		local node_testing = minetest.get_node(pos_testing)
		local param2_testing = node_testing.param2
		if not minetest.registered_nodes[node_testing.name] then
			return 0
		end
		if minetest.registered_nodes[node_testing.name].liquidtype
		~= "flowing" then
			return 0
		else
			return direction
		end
	elseif minetest.registered_nodes[name].liquidtype == "flowing" then
		local node_testing = minetest.get_node(pos_testing)
		local param2_testing = node_testing.param2
		if not minetest.registered_nodes[node_testing.name] then
			return 0
		end
		if minetest.registered_nodes[node_testing.name].liquidtype
		== "source" then
			return -direction
		elseif minetest.registered_nodes[node_testing.name].liquidtype
		== "flowing" then
			if param2_testing < node.param2 then
				if (node.param2 - param2_testing) > 6 then
					return -direction
				else
					return direction
				end
			elseif param2_testing > node.param2 then
				if (param2_testing - node.param2) > 6 then
					return direction
				else
					return -direction
				end
			end
		end
	end
	return 0
end

local quick_flow = function(pos,node)
	local x = 0
	local z = 0

	if not node_is_liquid(node)  then
		return {x=0,y=0,z=0}
	end

	x = x + quick_flow_logic(node,{x=pos.x-1,y=pos.y,z=pos.z},-1)
	x = x + quick_flow_logic(node,{x=pos.x+1,y=pos.y,z=pos.z}, 1)
	z = z + quick_flow_logic(node,{x=pos.x,y=pos.y,z=pos.z-1},-1)
	z = z + quick_flow_logic(node,{x=pos.x,y=pos.y,z=pos.z+1}, 1)

	return to_unit_vector({x=x,y=0,z=z})
end

flowlib.quick_flow = quick_flow


	--if not in water but touching, move centre to touching block
	--x has higher precedence than z
	--if pos changes with x, it affects z
local move_centre = function(pos,realpos,node,radius)
	if is_touching(realpos.x,pos.x,radius) then
		if is_liquid({x=pos.x-1,y=pos.y,z=pos.z}) then
			node = minetest.get_node({x=pos.x-1,y=pos.y,z=pos.z})
			pos = {x=pos.x-1,y=pos.y,z=pos.z}
		elseif is_liquid({x=pos.x+1,y=pos.y,z=pos.z}) then
			node = minetest.get_node({x=pos.x+1,y=pos.y,z=pos.z})
			pos = {x=pos.x+1,y=pos.y,z=pos.z}
		end
	end
	if is_touching(realpos.z,pos.z,radius) then
		if is_liquid({x=pos.x,y=pos.y,z=pos.z-1}) then
			node = minetest.get_node({x=pos.x,y=pos.y,z=pos.z-1})
			pos = {x=pos.x,y=pos.y,z=pos.z-1}
		elseif is_liquid({x=pos.x,y=pos.y,z=pos.z+1}) then
			node = minetest.get_node({x=pos.x,y=pos.y,z=pos.z+1})
			pos = {x=pos.x,y=pos.y,z=pos.z+1}
		end
	end
	return pos,node
end

flowlib.move_centre = move_centre


--the main flow function
function set_flow(pos,object,divider)
    pos.y = pos.y + object:get_properties().collisionbox[2]+0.05
    local direction = quick_flow(pos,minetest.get_node(pos))
    object:add_velocity(vector.divide(direction,divider))
end

--test if a node is water
local function testwater(pos)
  return(minetest.get_item_group(minetest.get_node(pos).name, "water"))
end

local function splashy(object,pos)
	local collisionbox = object:get_properties().collisionbox

	--base amount off top and bottom of collision box distance
	local amount = math.abs(math.floor((collisionbox[2]-collisionbox[5])*10))*2

	minetest.add_particlespawner({
			amount = amount,
			time = 0.01,
			minpos = {x=pos.x+collisionbox[1], y=pos.y+collisionbox[2], z=pos.z+collisionbox[3]},
			maxpos = {x=pos.x+collisionbox[4], y=pos.y+collisionbox[5], z=pos.z+collisionbox[6]},
			minvel = {x=0, y=0, z=0},
			maxvel = {x=0, y=0, z=0},
			minacc = {x=0, y=0.5, z=0},
			maxacc = {x=0, y=1, z=0},
			minexptime = 2,
			maxexptime = 3,
			minsize = 1,
			maxsize = 2,

			collisiondetection = true,
			collision_removal = true,

			object_collision = false,

			vertical = false,
			-- If true face player using y axis only
			texture = "bubble_2.png",
	})
	minetest.sound_play("sploosh", {
		pos = pos,
		max_hear_distance = 100,
		gain = 0.5,
		pitch = math.random(70,110)/100,
	})
end

--make splash noise and particles
function splash(object,pos)
	object:get_luaentity().in_water = testwater(pos)
	local vel = object:get_velocity()
	--create splashes
	if object:get_luaentity().old_in_water == 0 and object:get_luaentity().in_water > 0 and vel.y < -1 then
		splashy(object,pos)
	end

	object:get_luaentity().old_in_water = object:get_luaentity().in_water
end


local function player_splashy(player,pos)
	local collisionbox = player:get_properties().collisionbox

	--base amount off top and bottom of collision box distance
	local amount = math.abs(math.floor((collisionbox[2]-collisionbox[5])*10))*2

	minetest.add_particlespawner({
			amount = amount,
			time = 0.01,
			minpos = {x=pos.x+collisionbox[1], y=pos.y+collisionbox[2], z=pos.z+collisionbox[3]},
			maxpos = {x=pos.x+collisionbox[4], y=pos.y+collisionbox[5], z=pos.z+collisionbox[6]},
			minvel = {x=0, y=0, z=0},
			maxvel = {x=0, y=0, z=0},
			minacc = {x=0, y=0.5, z=0},
			maxacc = {x=0, y=1, z=0},
			minexptime = 2,
			maxexptime = 3,
			minsize = 1,
			maxsize = 2,

			collisiondetection = true,
			collision_removal = true,

			object_collision = false,

			vertical = false,
			-- If true face player using y axis only
			texture = "bubble_2.png",
	})
	minetest.sound_play("sploosh", {
		pos = pos,
		max_hear_distance = 100,
		gain = 0.5,
		pitch = math.random(70,110)/100,
	})
end

--make player's splash noise and particles
minetest.register_globalstep(function(dtime)
	for _,player in ipairs(minetest.get_connected_players()) do
		if player:get_hp() > 0 or not minetest.settings:get_bool("enable_damage") then
			local meta = player:get_meta()
			local pos = player:get_pos()
			local vel = player:get_player_velocity()
			--local collisionbox = player:get_properties().collisionbox

			local in_water = testwater(pos)


			meta:set_int("in_water",in_water)


			if meta:get_int("old_in_water") == 0 and meta:get_int("in_water") > 0 and vel.y < -1 then
				player_splashy(player,pos)
			end


			--then set for old value
			meta:set_int("old_in_water",in_water)
		end
	end
end)
