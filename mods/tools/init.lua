
--when tool breaks leaves a stick
local groups = {"wood","stone","iron","gold","diamond"}

for i = 1,table.getn(groups) do
  --make it so wood and stone can't mine hard ores
  --{"wood","stone","iron","gold","diamond"}
  local times = {1,2,3,4,4}
  local looper = i
  local counter = 0
  timey = {}
  for j = 1,times[i] do
    counter = counter + 1
    timey[counter] = (1*counter)/(i/(i*2))
  end

  --axe
  minetest.register_tool("tools:"..groups[i].."_axe",
      {
          description = groups[i]:gsub("^%l", string.upper).." Axe",
          groups = {wood = 1},
          inventory_image = "default_tool_"..groups[i].."axe.png",
          wield_image = "default_tool_"..groups[i].."axe.png",
          liquids_pointable = false,
          -- See "Tools" section
          tool_capabilities = {
              full_punch_interval = 1.0,
              max_drop_level = 0,
              groupcaps = {
                  -- For example:
                  wood = { times = timey,uses = i*5, maxlevel = i},
              },
              ----damage_groups = {groupname = damage},
            },

          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )


  minetest.register_tool("tools:"..groups[i].."_pickaxe",
      {
          description = groups[i]:gsub("^%l", string.upper).." Pickaxe",
          groups = {wood = 1},
          inventory_image = "default_tool_"..groups[i].."pick.png",
          wield_image = "default_tool_"..groups[i].."pick.png",
          liquids_pointable = false,
          -- See "Tools" section
          tool_capabilities = {
              full_punch_interval = 1.0,
              max_drop_level = 0,
              groupcaps = {
                  -- For example:
                  stone = {times = timey,
                           uses = i*5, maxlevel = i},
              },
              --damage_groups = {groupname = damage},
          },

          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )
  minetest.register_tool("tools:"..groups[i].."_shovel",
      {
          description = groups[i]:gsub("^%l", string.upper).." Pickaxe",
          groups = {wood = 1},
          inventory_image = "default_tool_"..groups[i].."shovel.png",
          wield_image = "default_tool_"..groups[i].."shovel.png^[transform4",
          liquids_pointable = false,
          -- See "Tools" section
          tool_capabilities = {
              full_punch_interval = 1.0,
              max_drop_level = 0,
              groupcaps = {
                  -- For example:
                  dirt = {times = timey,
                           uses = i*5, maxlevel = i},
              },
              --damage_groups = {groupname = damage},
          },

          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )

  minetest.register_tool("tools:"..groups[i].."_hoe",
      {
          description = groups[i]:gsub("^%l", string.upper).." Hoe",
          groups = {wood = 1},
          inventory_image = "farming_tool_"..groups[i].."hoe.png",
          --wield_image = "farming_tool_"..groups[i].."hoe.png^[transform4",
          liquids_pointable = false,
          -- See "Tools" section
          tool_capabilities = {
              full_punch_interval = 1,
              max_drop_level = 0,
              groupcaps = {
                  --emulate a shovel
                  dirt = {times = timey,
                           uses = i, maxlevel = i},
              },
              --damage_groups = {groupname = damage},
          },
          --acts like on rightclick (farming action)
          on_place = function(itemstack, placer, pointed_thing)
            local node = minetest.get_node(pointed_thing.under).name
            if minetest.get_item_group(node,"dirt") > 0 then
              --cancel if the node is farmland
              if minetest.get_item_group(node,"farmland") > 0 then return end
              --cancel if no air above
              if minetest.get_node({x=pointed_thing.under.x,y=pointed_thing.under.y+1,z=pointed_thing.under.z}).name ~= "air" then return end
              minetest.set_node(pointed_thing.under,{name="nodes:dry_farmland"})
              minetest.sound_play(sounds.dirt().place.name, {
                pos = placer:get_pos(),
                max_hear_distance = 100,
                gain = 1.0,
                pitch = math.random(70,100)/100,
              })
              --call the tool break function
              tool_break(itemstack, placer, pointed_thing.under, {wear=(5-itemstack:get_tool_capabilities().groupcaps.dirt.uses)*500})
              return(itemstack)
            end
          end,


          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )

  minetest.register_tool("tools:"..groups[i].."_paxel",
      {
          description = groups[i]:gsub("^%l", string.upper).." Paxel",
          groups = {wood = 1},
          inventory_image = "default_tool_"..groups[i].."shovel.png^default_tool_"..groups[i].."pick.png^default_tool_"..groups[i].."axe.png",
          wield_image = "default_tool_"..groups[i].."shovel.png^default_tool_"..groups[i].."pick.png^default_tool_"..groups[i].."axe.png",
          liquids_pointable = false,
          -- See "Tools" section
          tool_capabilities = {
              full_punch_interval = 1.0,
              max_drop_level = 0,
              groupcaps = {
                  -- For example:
                  dirt = {times = timey,
                           uses = i*15, maxlevel = i},
                  wood = {times = timey,
                          uses = i*15, maxlevel = i},
                  stone = {times = timey,
                         uses = i*15, maxlevel = i},
              },
              --damage_groups = {groupname = damage},
          },

          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )
end

minetest.register_tool("tools:shears",
    {
        description = "Shears",
        groups = {shears = 1},
        inventory_image = "shears.png",
        wield_image = "shears.png^[transform4",
        liquids_pointable = false,
        -- See "Tools" section
        tool_capabilities = {
            full_punch_interval = 1.0,
            max_drop_level = 0,
            groupcaps = {
                -- For example:
                leaves = {times = {[1] = 0.1, [2] = 0.05},
                         uses = 40, maxlevel = 2},
            },
            --damage_groups = {groupname = damage},
        },

        after_use = function(itemstack, user, node, digparams)
            tool_break(itemstack, user, node, digparams)
        end,

    }
)


minetest.register_tool("tools:flint_and_steel",
    {
        description = "Flint and Steel",
        groups = {fire_starter = 1},
        inventory_image = "flint_and_steel.png",
        wield_image = "flint_and_steel.png^[transform4",
        liquids_pointable = false,
        on_place = function(itemstack, placer, pointed_thing)
          local node = minetest.get_node(pointed_thing.under).name
          if minetest.get_item_group(node,"flammable") > 0 then
            minetest.sound_play("lighter", {
              pos = placer:get_pos(),
              max_hear_distance = 100,
              gain = 1.0,
              pitch = math.random(80,110)/100,
            })
            minetest.add_node(pointed_thing.above,{name="fire:fire"})
            --call the tool break function
            tool_break(itemstack, placer, pointed_thing.under, {wear=(1000)})
            return(itemstack)
          end
        end,

    }
)
