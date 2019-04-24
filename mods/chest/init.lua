--this is a hack of default minetest game chest.lua

-- throw items everywhere when inventory is mined
local function throw_inventory(pos, inventory)
	local inv = minetest.get_meta(pos):get_inventory()
  --go through lists
  local list = inv:get_list(inventory)
  --go through table within lists
  for i,g in pairs(list) do
    --remove from inventory and drop the item
    local item = inv:get_stack(inventory, i):get_name()
    local wear = inv:get_stack(inventory, i):get_wear()
    --add as many items as in the stack
    for i = 1,inv:get_stack(inventory, i):get_count() do
      local object = minetest.add_item(pos,item.." 1 "..wear)
			object:set_velocity({x=math.random(-7,7)*math.random(), y=math.random(5,7)*math.random(), z=math.random(-7,7)*math.random()})
      object:get_luaentity().age = 0+math.random()
    end
    --remove the item from inventory
    inv:set_stack(inventory, i, "")
  end
end


local chest = {}

function chest.get_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
	local formspec =
		"size[8,9]" ..
		"list[nodemeta:" .. spos .. ";main;0,0.3;8,4;]" ..
		"list[current_player;main;0,4.85;9,1;]" ..
	  "list[current_player;main;0,6.08;9,3;9]" ..
		"listring[nodemeta:" .. spos .. ";main]" ..
		"listring[current_player;main]"
	return formspec
end

function chest.chest_lid_close(pn)
	local chest_open_info = chest.open_chests[pn]
	local pos = chest_open_info.pos
	local sound = chest_open_info.sound
	local swap = chest_open_info.swap

	chest.open_chests[pn] = nil
	for k, v in pairs(chest.open_chests) do
		if v.pos.x == pos.x and v.pos.y == pos.y and v.pos.z == pos.z then
			return true
		end
	end

	local node = minetest.get_node(pos)
	minetest.after(0.2, minetest.swap_node, pos, { name = "chest:" .. swap,
			param2 = node.param2 })
	minetest.sound_play(sound,{
    gain = 0.3,
    pos = pos,
    max_hear_distance = 30,
    pitch = math.random(80,110)/100
  })
end

chest.open_chests = {}

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "chest:chest" then
		return
	end
	if not player or not fields.quit then
		return
	end
	local pn = player:get_player_name()

	if not chest.open_chests[pn] then
		return
	end

	chest.chest_lid_close(pn)
	return true
end)

minetest.register_on_leaveplayer(function(player)
	local pn = player:get_player_name()
	if chest.open_chests[pn] then
		chest.chest_lid_close(pn)
	end
end)

function chest.register_chest(name, d)
	local def = table.copy(d)
	def.drawtype = "mesh"
	def.visual = "mesh"
	def.paramtype = "light"
	def.paramtype2 = "facedir"
	def.legacy_facedir_simple = true
	def.is_ground_content = false


	def.on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end
  def.on_destruct = function(pos)
    throw_inventory(pos, "main")
  end

	def.on_rightclick = function(pos, node, clicker)
		minetest.sound_play(def.sound_open, {
      gain = 0.3,
      pos = pos,
			max_hear_distance = 30,
      pitch = math.random(80,110)/100
    })
		minetest.swap_node(pos, {
				name = "chest:" .. name .. "_open",
				param2 = node.param2 })
		minetest.after(0.2, minetest.show_formspec,
				clicker:get_player_name(),
				"chest:chest", chest.get_chest_formspec(pos))
		chest.open_chests[clicker:get_player_name()] = { pos = pos,
				sound = def.sound_close, swap = name }
	end

	def.on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.log("action", player:get_player_name() ..
			" moves stuff in chest at " .. minetest.pos_to_string(pos))
	end
	def.on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" moves " .. stack:get_name() ..
			" to chest at " .. minetest.pos_to_string(pos))
	end
	def.on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name() ..
			" takes " .. stack:get_name() ..
			" from chest at " .. minetest.pos_to_string(pos))
	end

	local def_opened = table.copy(def)
	local def_closed = table.copy(def)

	def_opened.mesh = "chest_open.obj"
	for i = 1, #def_opened.tiles do
		if type(def_opened.tiles[i]) == "string" then
			def_opened.tiles[i] = {name = def_opened.tiles[i], backface_culling = true}
		elseif def_opened.tiles[i].backface_culling == nil then
			def_opened.tiles[i].backface_culling = true
		end
	end
	def_opened.drop = "chest:" .. name
	def_opened.groups.not_in_creative_inventory = 1
	def_opened.selection_box = {
		type = "fixed",
		fixed = { -1/2, -1/2, -1/2, 1/2, 3/16, 1/2 },
	}
	def_opened.can_dig = function()
		return false
	end
	def_opened.on_blast = function() end

	def_closed.mesh = nil
	def_closed.drawtype = nil
	def_closed.tiles[6] = def.tiles[5] -- swap textures around for "normal"
	def_closed.tiles[5] = def.tiles[3] -- drawtype to make them match the mesh
	def_closed.tiles[3] = def.tiles[3].."^[transformFX"

	minetest.register_node("chest:" .. name, def_closed)
	minetest.register_node("chest:" .. name .. "_open", def_opened)

end

chest.register_chest("chest", {
	description = "Chest",
	tiles = {
		"default_chest_top.png",
		"default_chest_top.png",
		"default_chest_side_big.png",
		"default_chest_side_big.png",
		"default_chest_front.png",
		"default_chest_inside.png"
	},
	sounds = sounds.wood(),
	sound_open = "default_chest_open",
	sound_close = "default_chest_close",
	groups = {wood = 1,flammable = 1},
})
