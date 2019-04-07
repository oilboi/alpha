
--when tool breaks leaves a stick

minetest.register_tool("tools:wood_axe",
    {
        description = "Wood Axe",

        groups = {wood = 1},
        -- key = name, value = rating; rating = 1..3.
        -- If rating not applicable, use 1.
        -- e.g. {wool = 1, fluffy = 3}
        --      {soil = 2, outerspace = 1, crumbly = 1}
        --      {bendy = 2, snappy = 1},
        --      {hard = 1, metal = 1, spikes = 1}

        inventory_image = "default_tool_woodaxe.png",

        --inventory_overlay = "overlay.png",
        -- An overlay which does not get colorized

        wield_image = "default_tool_woodaxe.png",

        ---wield_overlay = "",

        --palette = "",
        -- An image file containing the palette of a node.
        -- You can set the currently used color as the "palette_index" field of
        -- the item stack metadata.
        -- The palette is always stretched to fit indices between 0 and 255, to
        -- ensure compatibility with "colorfacedir" and "colorwallmounted" nodes.

        --color = "0xFFFFFFFF",
        -- The color of the item. The palette overrides this.

        --wield_scale = {x = 1, y = 1, z = 1},

        --stack_max = 99,

        --range = 4.0,

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

        --node_placement_prediction = nil,
        -- If nil and item is node, prediction is made automatically.
        -- If nil and item is not a node, no prediction is made.
        -- If "" and item is anything, no prediction is made.
        -- Otherwise should be name of node which the client immediately places
        -- on ground when the player places the item. Server will always update
        -- actual result to client in a short moment.

        --node_dig_prediction = "air",
        -- if "", no prediction is made.
        -- if "air", node is removed.
        -- Otherwise should be name of node which the client immediately places
        -- upon digging. Server will always update actual result shortly.

        --sound = {breaks = "tool_break"},

        --on_place = function(itemstack, placer, pointed_thing),
        -- Shall place item and return the leftover itemstack.
        -- The placer may be any ObjectRef or nil.
        -- default: minetest.item_place

        --on_secondary_use = function(itemstack, user, pointed_thing),
        -- Same as on_place but called when pointing at nothing.
        -- The user may be any ObjectRef or nil.
        -- pointed_thing: always { type = "nothing" }

        --on_drop = function(itemstack, dropper, pos),
        -- Shall drop item and return the leftover itemstack.
        -- The dropper may be any ObjectRef or nil.
        -- default: minetest.item_drop

        --on_use = function(itemstack, user, pointed_thing)
          --tool_break(itemstack, user, pointed_thing.under,{wear = -55})
        --end,

        --end
        -- default: nil
        -- Function must return either nil if no item shall be removed from
        -- inventory, or an itemstack to replace the original itemstack.
        -- e.g. itemstack:take_item(); return itemstack
        -- Otherwise, the function is free to do what it wants.
        -- The user may be any ObjectRef or nil.
        -- The default functions handle regular use cases.

        after_use = function(itemstack, user, node, digparams)
            tool_break(itemstack, user, node, digparams)
        end,
        -- default: nil
        -- If defined, should return an itemstack and will be called instead of
        -- wearing out the tool. If returns nil, does nothing.
        -- If after_use doesn't exist, it is the same as:
        --   function(itemstack, user, node, digparams)
        --     itemstack:add_wear(digparams.wear)
        --     return itemstack
        --   end
        -- The user may be any ObjectRef or nil.

        --_custom_field = whatever,
        -- Add your own custom fields. By convention, all custom field names
        -- should start with `_` to avoid naming collisions with future engine
        -- usage.
    }
)
