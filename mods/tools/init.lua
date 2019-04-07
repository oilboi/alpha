
--when tool breaks leaves a stick

minetest.register_tool("tools:wood_axe",
    {
        description = "Wood Axe",

        groups = {wood = 1},

        inventory_image = "default_tool_woodaxe.png",



        wield_image = "default_tool_woodaxe.png",

        liquids_pointable = false,

        -- See "Tools" section
        tool_capabilities = {
            full_punch_interval = 1.0,
            max_drop_level = 0,
            groupcaps = {
                -- For example:
                wood = {times = {[1] = 0.5, [2] = 0.20, [3] = 0.00},
                         uses = 1, maxlevel = 1},
            },
            damage_groups = {groupname = damage},
        },

        after_use = function(itemstack, user, node, digparams)
            tool_break(itemstack, user, node, digparams)
        end,

    }
)
