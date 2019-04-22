--this has such a weird name to make sure it loads first

-- Set random seed for all other mods (Remember to make sure no other mod calls this function)
math.randomseed(os.time())

print("initialized math.random() seed")

--set the server tick to 0 for max performance
minetest.settings:set("dedicated_server_step", 0)

--set the liquid update fast for nice flow
minetest.settings:set("liquid_update", 0.3)


--this only works for singleplayer

--set the bobbing
minetest.settings:set("view_bobbing_amount", 2.0)
minetest.settings:set("fall_bobbing_amount", 2.0)
