local number_of_paintings = 4
for i = 1,number_of_paintings do -- the number of paintings to create (painting1.png, painting2.png) (textures are held in texture mod)
  minetest.register_node("painting:painting_" .. i, {
    description = "Painting (Should not have)",
    drawtype = "nodebox",
    inventory_image = "painting"..i..".png",
    tiles = {"painting"..i..".png","default_wood.png","default_wood.png","default_wood.png","default_wood.png","default_wood.png"},
    paramtype = "light",
    paramtype2 = "wallmounted",
    is_ground_content = false,
    groups = {wood=1,painting=1,instant=1,attached_node=1},
    sounds = sounds.wood(),
    drop = "painting:painting_inv", --make it drop craftitem
    node_box = {
      type = "wallmounted",
      wall_side = {-0.5, -0.5, -0.5, -0.45, 0.5, 0.5},
    },
  })
end

--register the craft item painting (generates a random painting)
minetest.register_craftitem("painting:painting_inv", {
	description = "Painting",
	inventory_image = "painting_inv.png",
	on_place = function(itemstack, placer, pointed_thing)
    --don't let players place on wallmounted nodes
    if minetest.registered_nodes[minetest.get_node(pointed_thing.under).name].paramtype2 == "wallmounted" then
      return
    end
    --get wallmounted direction
		local wdir = minetest.dir_to_wallmounted(vector.subtract(pointed_thing.under,pointed_thing.above))
    --only let players place paintings on wall vertically
    if wdir <= 1 then
      return
    end
    --select a painting
    local painting = "painting:painting_"..math.random(1,number_of_paintings)
    --place the painting
    minetest.item_place(ItemStack(painting), placer, pointed_thing, wdir)
		itemstack:take_item()
		return(itemstack)
	end,
})
