--this has such a weird name to make sure it loads first

-- Set random seed for all other mods (Remember to make sure no other mod calls this function)
math.randomseed(os.time())

print("initialized math.random() seed")
