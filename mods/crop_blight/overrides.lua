----------------------------------------------------------------------------
--                     NO BLIGHT SPOT PLACED HERE 
----------------------------------------------------------------------------
--List of drawtype="normal" nodes on which blight spot should not be placed.
local no_blight_spot_nodes = {
    "moreblocks:coal_glass",
    "moreblocks:clean_glass",
    "moreblocks:glow_glass",
    "moreblocks:super_glow_glass",
    "moreblocks:iron_glass",
    "moreblocks:trap_glass",
    "moreblocks:trap_glow_glass",
    "moreblocks:trap_super_glow_glass",
    "moreblocks:all_faces_jungle_tree",
    "default:glass",
    "default:obsidian_glass",
    "default:meselamp",
    "default:snowblock",
    "default:dirt_with_snow",
    "default:ice",
    "seasons:flowing_ice",
    "default:sand",
    "default:desert_sand",
    "default:sandstone",
    "default:sandstonebrick",
    "default:desert_cobble",
    "default:desert_stone",
    "default:desert_stonebrick",
    "default:cactus",
    "default:cactus_brick",
    "default:steelblock",
    "default:jungletree",
    "default:gravel",
}
for i, name in ipairs(no_blight_spot_nodes) do
    if minetest.registered_nodes[name] then
        minetest.override_item(name, {
            crop_blight_settings = {
                reverse_spot_default = true,
            }
        })
    end
end


----------------------------------------------------------------------------
--                 LIGHT GOES THROUGH, BUT NOT BLIGHT 
----------------------------------------------------------------------------
--List of nodes which allow light to pass through, but should block blight from passing through.
local airtight_translucent_nodes = {
    "default:glass",
    "default:obsidian_glass",
    "doors:door_glass_a",
    "doors:door_glass_b",
    "doors:door_steel_a",
    "doors:door_steel_b",
    "doors:door_wood_a",
    "doors:door_wood_b",
    "doors:door_obsidian_glass_a",
    "doors:door_obsidian_glass_b",
    "doors:hidden",
    "doors:trapdoor_steel",
    "doors:trapdoor",
    "home_mod:glass_clean_lead_pane",
    "moreblocks:coal_glass",
    "moreblocks:clean_glass",
    "moreblocks:glow_glass",
    "moreblocks:super_glow_glass",
    "moreblocks:iron_glass",
    "default:meselamp",
    "default:water_source",
    "default:water_flowing",
    "walls:cobble",
    "walls:desertcobble",
    "walls:mossycobble",
}
for i, name in ipairs(airtight_translucent_nodes) do
    if minetest.registered_nodes[name] then
        minetest.override_item(name, {
            crop_blight_settings = {
                reverse_seal_default = true,
            }
        })
    end
end


----------------------------------------------------------------------------
--                 DECONTAMINATING NODES 
----------------------------------------------------------------------------
--List of nodes which will decontaminate a player
local decontaminating_nodes = {
    "default:water_source",
    "default:river_water_source",
    "default:water_flowing",
    "default:river_water_flowing",
    "default:meselamp",
}
for i, name in ipairs(decontaminating_nodes) do
    if minetest.registered_nodes[name] then
        minetest.override_item(name, {
            crop_blight_settings = {
                decontaminates_player = true,
            }
        })
    end
end


----------------------------------------------------------------------------
--                          INFECTABLE NODES
----------------------------------------------------------------------------
--Override for a few items by group name
local blight_settings_by_group = {
    ["flora"]  = {infected_version = "default:dry_shrub", chance = 1},
    ["wheat"]  = {infected_version = "crop_blight:wheat_short", chance = 1},
    ["cotton"] = {infected_version = "default:dry_shrub", chance = 3},
    ["seed"]   = {infected_version = "air", chance = 1},
}
for group, settings in pairs(blight_settings_by_group) do
    for name, def in pairs(minetest.registered_nodes) do
        if minetest.get_item_group(def.name, group) > 0 then
            minetest.override_item(name, {
                crop_blight_settings = {
                    infectable_settings = {
                        chance = settings.chance,
                        infected_version = settings.infected_version,
                    },
                }
            })
        end
    end
end

--Override for a few items by name (overwrites any blight settings assigned previously)
local blight_settings_by_name = {  
    ["default:tree"]          = {infected_version = "crop_blight:tree_blighted", chance = 1},
    ["default:pine_tree"]     = {infected_version = "crop_blight:pine_tree_blighted", chance = 1},
    ["default:acacia_tree"]   = {infected_version = "crop_blight:acacia_tree_blighted", chance = 1},
    ["default:aspen_tree"]    = {infected_version = "crop_blight:aspen_tree_blighted", chance = 1},
    ["default:grass_1"]       = {infected_version = "air", chance = 1},
    ["default:grass_2"]       = {infected_version = "air", chance = 1},
    ["farming:wheat_6"]       = {infected_version = "crop_blight:wheat_tall", chance = 1},
    ["farming:wheat_7"]       = {infected_version = "crop_blight:wheat_tall", chance = 1},
    ["farming:wheat_8"]       = {infected_version = "crop_blight:wheat_tall", chance = 1},
    ["farming:soil_wet"]      = {infected_version = "crop_blight:soil_wet_blighted", chance = 1},
    --["farming:desert_sand_soil_wet"]  = {infected_version = "crop_blight:desert_sand_soil_wet_blighted", chance = 1},
}
for name, settings in pairs(blight_settings_by_name) do
    if minetest.registered_nodes[name] then
        minetest.override_item(name, {
            crop_blight_settings = {
                infectable_settings = {
                    chance = settings.chance,
                    infected_version = settings.infected_version,
                },
            }
        })
    end
end


----------------------------------------------------------------------------
--                          NEW FUNCTIONALITY
----------------------------------------------------------------------------
--OVERRIDE MOREBOCKS SWEEPER-- Sweeper cleans blight spots
if minetest.get_modpath("moreblocks") then
    minetest.override_item("moreblocks:sweeper", {
        on_use = function(itemstack, player, pointed_thing)
            if not pointed_thing or pointed_thing.type ~= "node" then
                return
            else
                local chk_node = minetest.get_node(pointed_thing.above)
                if chk_node and minetest.get_item_group(chk_node.name, "sweepable") > 0 then
                    minetest.set_node(pointed_thing.above, {name = "air"})
                    minetest.sound_play("crop_blight_sweeper",
                        {
                            pos = pointed_thing.above,
                            gain = 1,
                            max_hear_distance = 5,
                            loop = false,
                        }
                    )
                end
            end
        end,
    })
end