
--when tool breaks leaves a stick
local groups = {"wood","stone","iron","gold","diamond"}

for i = 1,table.getn(groups) do
  print(groups[i])
  minetest.register_tool("tools:"..groups[i].."_axe",
      {
          description = groups[i].."Axe",
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
                  wood = {times = {[1] = 10/i, [2] = 5/i, [3] = 2/i},
                           uses = i*20, maxlevel = i},
              },
              damage_groups = {groupname = damage},
          },

          after_use = function(itemstack, user, node, digparams)
              tool_break(itemstack, user, node, digparams)
          end,

      }
  )
end
