----------------------------------------------------------------------------
--                                 SETTINGS
----------------------------------------------------------------------------
--Define shape of hollow tree
local hollow_tree = {
    {-0.5, -0.5, -0.5, -0.35, 0.5, 0.5},
    {0.35, -0.5, -0.5, 0.5, 0.5, 0.5},
    {-0.5, -0.5, 0.35, 0.5, 0.5, 0.5},
    {-0.5, -0.5, -0.5, 0.5, 0.5, -0.35},
}

--Neighbor Definition
local neighbors = { --Positions to add to get the nodes around the current node
    {x= 1,y= 0,z= 0}, --East  (1)
    {x=-1,y= 0,z= 0}, --West  (2)
    {x= 0,y= 0,z= 1}, --North (3)
    {x= 0,y= 0,z=-1}, --South (4)
    {x= 0,y=-1,z= 0}, --Under (5)
    {x= 0,y= 1,z= 0}, --Above (6)
      --extended--
    {x= 1,y= 1,z= 1}, --ETN   (7)
    {x= 1,y= 1,z=-1}, --ETS   (8)
    {x=-1,y= 1,z= 1}, --WTN   (9)
    {x=-1,y= 1,z=-1}, --WTS  (10)
}


----------------------------------------------------------------------------
--                             NODE FUNCTIONS
----------------------------------------------------------------------------
--PLACE TREE FUNGUS-- Controls how shelf fungus is placed on rotted trees
local function place_artists_fungus(pos) --pos is tree node
    local chk_pos = vector.add(pos, neighbors[math.random(1,4)]) --pick random side of tree node
    local chk_node = minetest.get_node(chk_pos)
    if chk_node.name == "air" then
        local wall_direction = minetest.dir_to_wallmounted(vector.subtract(pos, chk_pos))
        minetest.set_node(chk_pos,{name = "crop_blight:artists_fungus", param2 = wall_direction})
    end
end


----------------------------------------------------------------------------
--                             NODE REGISTRATIONS
----------------------------------------------------------------------------
--Blighted Soil Wet
crop_blight.register_blighted_node("crop_blight:soil_wet_blighted", {
	description = "Blighted Wet Soil",
    drop = {
        max_items = 1,
        items = {
            {items = {"flowers:mushroom_spores_red"}, rarity = 5}, 
            {items = {"default:dirt"}}
        }
    },
    tiles = {
        "default_dirt.png^farming_soil_wet.png", --^crop_blight_farm_top.png",
        "default_dirt.png^farming_soil_wet_side.png^crop_blight_farm_side.png",
    },
    groups = {crumbly = 3, not_in_creative_inventory = 1, soil=3, grassland = 1, farming_soil = 1, scatters_blight = 1},
    sounds = default.node_sound_dirt_defaults(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
    end,
    crop_blight_settings = {
        contaminates_player = true,
        scatter_on_dig = true,
    },
})

--Blighted Desert Sand Soil Wet
crop_blight.register_blighted_node("crop_blight:desert_sand_soil_wet_blighted", {
	description = "Blighted Desert Sand Soil Wet",
	drop = {
        max_items = 1,
        items = {
            {items = {}, rarity = 10}, 
            {items = {"default:desert_sand"}}
        }
    },
    tiles = {
        "farming_desert_sand_soil_wet.png", 
        "farming_desert_sand_soil_wet_side.png^crop_blight_farm_side.png"
    },
    groups = {crumbly = 3, not_in_creative_inventory = 1, soil=3, desert = 1, scatters_blight = 1},
    sounds = default.node_sound_sand_defaults(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
    end,
})

--Blighted Tree
crop_blight.register_blighted_node("crop_blight:tree_blighted", {
    description = "Blighted Tree",
    drawtype = "nodebox",
    node_box = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_tree_top.png^crop_blight_tree_hole_1.png", 
        "default_tree_top.png^crop_blight_tree_hole_1.png",
        "default_tree.png^crop_blight_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
    drop = 'default:wood',
    sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        if math.random() < 1/5 then --one in 5 chance of setting artist's fungus
            place_artists_fungus(pos)
        end
    end,
    on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
    crop_blight_settings = {contaminates_player = false},
})

--Blighted Pine Tree
crop_blight.register_blighted_node("crop_blight:pine_tree_blighted", {
    description = "Blighted Pine Tree",
    drawtype = "nodebox",
    node_box = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_pine_tree_top.png^crop_blight_tree_hole_2.png", 
        "default_pine_tree_top.png^crop_blight_tree_hole_2.png", 
        "default_pine_tree.png^crop_blight_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
    drop = 'default:pine_wood',
	sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        if math.random() < 1/5 then
            place_artists_fungus(pos)
        end
    end,
    on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
    crop_blight_settings = {contaminates_player = false},
})

--Blighted Acacia Tree
crop_blight.register_blighted_node("crop_blight:acacia_tree_blighted", {
    description = "Blighted Acacia Tree",
    drawtype = "nodebox",
    node_box = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_acacia_tree_top.png^crop_blight_tree_hole_2.png", 
        "default_acacia_tree_top.png^crop_blight_tree_hole_2.png", 
        "default_acacia_tree.png^crop_blight_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
    drop = 'default:acacia_wood',
	sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        if math.random() < 1/8 then
            place_artists_fungus(pos)
        end
    end,
    on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
    crop_blight_settings = {contaminates_player = false},
})

--Blighted Aspen Tree
crop_blight.register_blighted_node("crop_blight:aspen_tree_blighted", {
    description = "Blighted Aspen Tree",
    drawtype = "nodebox",
    node_box = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_aspen_tree_top.png^crop_blight_tree_hole_1.png", 
        "default_aspen_tree_top.png^crop_blight_tree_hole_1.png", 
        "default_aspen_tree.png^crop_blight_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1},
    drop = 'default:aspen_wood',
	sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        if math.random() < 1/8 then
            place_artists_fungus(pos)
        end
    end,
    on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
    crop_blight_settings = {contaminates_player = false},
})

--Blighted Wheat short
crop_blight.register_blighted_node("crop_blight:wheat_short", {
    description = "Blighted Wheat",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"crop_blight_wheat_short.png"},
    paramtype = "light",
    paramtype2 = "meshoptions",
    drop = "default:dry_shrub",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1, not_in_creative_inventory = 1, replaced_by_snow = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
})

--Blighted Wheat Tall
crop_blight.register_blighted_node("crop_blight:wheat_tall", {
    description = "Blighted Wheat",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"crop_blight_wheat_tall.png"},
    paramtype = "light",
    paramtype2 = "meshoptions",
    drop = "default:dry_shrub",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1, not_in_creative_inventory = 1, replaced_by_snow = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
})

--Blight Spot --
for i = 1, 3 do
    crop_blight.register_blighted_node("crop_blight:blight_spot_"..i, {
        description = "Blight",
        drop = "",
        tiles = {"crop_blight_blight_spot_"..i..".png"},
        use_texture_alpha = true,
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "wallmounted",
        sunlight_propagates = true,
        walkable = false,
        pointable = false,
        buildable_to = true,
        floodable = true,
        groups = {not_in_creative_inventory = 1, attached_node = 1, flammable = 1, sweepable = 1, replaced_by_snow = 1},
        node_box = {
            type = "fixed",
            fixed = { -0.5, -0.49, -0.5, 0.5, -0.49, 0.5 },
        },
    })
end

--Artist's Fungus
crop_blight.register_blighted_node("crop_blight:artists_fungus", {
	description = "Artists Fungus",
	tiles = { --node box is defined so that fungus is laying on its back in 'normal' position. Wallmounted puts it correctly on the tree
        "crop_blight_artists_fungus_front.png", -- front of fungus
        "crop_blight_artists_fungus_back.png",  -- back of fungus
        "crop_blight_artists_fungus_left.png",  -- left of fungus
        "crop_blight_artists_fungus_right.png", -- right of fungus
        "crop_blight_artists_fungus_top.png",   -- top of fungus
        "crop_blight_artists_fungus_bot.png",   -- bottom of fungus
    },
	inventory_image = "crop_blight_artists_fungus_front.png",
	wield_image = "crop_blight_artists_fungus_front.png",
	drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    drop = "flowers:mushroom_brown",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, not_in_creative_inventory=1, attached_node=1, scatters_blight = 1},
    sounds = default.node_sound_leaves_defaults(),
    node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.0625, 0.125, -0.3125, 0.0625},
			{-0.0625, -0.5, -0.0625, 0.0625, -0.375, 0.125},
			{-0.1875, -0.5, 0, 0.1875, -0.25, 0.0625},
			{-0.25, -0.5, 0, 0.25, -0.3125, 0.0625},
			{-0.0625, -0.5, -0.125, 0.0625, -0.4375, -0.0625},
			{-0.1875, -0.5, 0.0625, 0.1875, -0.3125, 0.125},
			{-0.125, -0.5, 0, 0.125, -0.1875, 0.0625},
			{-0.125, -0.5, 0.0625, 0.125, -0.25, 0.125},
		}
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3}
	},
    on_place = function(itemstack, placer, pointed_thing)
        local wallmounted = minetest.dir_to_wallmounted(vector.subtract(pointed_thing.under, pointed_thing.above))
        local place_item = itemstack
        if wallmounted == 0 then
            return
        elseif wallmounted == 1 then
            place_item:set_name("flowers:mushroom_brown")
        else
            place_item:set_name("crop_blight:artists_fungus")
        end
        minetest.item_place(place_item, placer, pointed_thing, wallmounted)
        itemstack:set_name("crop_blight:artists_fungus")
        return itemstack
    end,
    on_timer = function()
        return false
    end,
    on_dig = function(pos, node, player) minetest.node_dig(pos, node, player) end,
    crop_blight_settings = {contaminates_player = false},
})