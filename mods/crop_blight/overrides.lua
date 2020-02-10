----------------------------------------------------------------------------
--                    ADD CROP_BLIGHT_SETTINGS 
----------------------------------------------------------------------------
--For drawtype = 'normal' reverse_spot_default = true means that a blight spot will not appear on the node
--For drawtype ~= 'normal' reverse_spot_default = true means that a blight spot will appear on the node
--For nodes which allow light to pass through, reverse_seal_default = tre means blight will not pass through the node

--Override by group name:
local crop_blight_settings_by_group = {
    ["flora"]  = {infectable_settings = {infected_version = "default:dry_shrub", chance = 1}},
    ["wheat"]  = {infectable_settings = {infected_version = "crop_blight:wheat_short", chance = 1}},
    ["cotton"] = {infectable_settings = {infected_version = "default:dry_shrub", chance = 3}},
    ["seed"]   = {infectable_settings = {infected_version = "air", chance = 1}},
}
for group, settings in pairs(crop_blight_settings_by_group) do
    for name, def in pairs(minetest.registered_nodes) do
        if minetest.get_item_group(def.name, group) > 0 then
            minetest.override_item(name, {
                crop_blight_settings = settings
            })
        end
    end
end

--Override by node name (will overwrite any settings assigned by group)
local crop_blight_settings_by_name = {
    --Doors
    ["doors:door_glass_a"]               = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_glass_b"]               = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_steel_a"]               = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_steel_b"]               = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_wood_a"]                = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_wood_b"]                = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_obsidian_glass_a"]      = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:door_obsidian_glass_b"]      = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:hidden"]                     = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:trapdoor_steel"]             = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["doors:trapdoor"]                   = {reverse_spot_default = false, reverse_seal_default = true},
    --Glass 
    ["home_mod:glass_clean_lead_pane"]   = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:coal_glass"]            = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["moreblocks:clean_glass"]           = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:glow_glass"]            = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:super_glow_glass"]      = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:iron_glass"]            = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:trap_glass"]            = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:trap_glow_glass"]       = {reverse_spot_default = false, reverse_seal_default = true},
    ["moreblocks:trap_super_glow_glass"] = {reverse_spot_default = false, reverse_seal_default = true},
    ["default:obsidian_glass"]           = {reverse_spot_default = false, reverse_seal_default = true},
    ["default:glass"]                    = {reverse_spot_default = true, reverse_seal_default = true},
    ["default:meselamp"]                 = {reverse_spot_default = false, reverse_seal_default = true, decontaminates_player = true,},
    --Water 
    ["default:water_source"]             = {reverse_spot_default = false, reverse_seal_default = true, decontaminates_player = true,},
    ["default:water_flowing"]            = {reverse_spot_default = false, reverse_seal_default = true, decontaminates_player = true,},
    ["default:river_water_source"]       = {reverse_spot_default = false, reverse_seal_default = true, decontaminates_player = true,}, 
    ["default:river_water_flowing"]      = {reverse_spot_default = false, reverse_seal_default = true, decontaminates_player = true,}, 
    --Noraml Nodes
    ["moreblocks:all_faces_jungle_tree"] = {reverse_spot_default = true},
    ["default:snowblock"]                = {reverse_spot_default = true, reverse_seal_default = true},
    ["default:dirt_with_snow"]           = {reverse_spot_default = true,},
    ["default:ice"]                      = {reverse_spot_default = true,},
    ["default:sand"]                     = {reverse_spot_default = true,},
    ["default:desert_sand"]              = {reverse_spot_default = true,},
    ["default:sandstone"]                = {reverse_spot_default = true,},
    ["default:sandstonebrick"]           = {reverse_spot_default = true,},
    ["default:desert_cobble"]            = {reverse_spot_default = true,},
    ["default:desert_stone"]             = {reverse_spot_default = true,},
    ["default:desert_stonebrick"]        = {reverse_spot_default = true,},
    ["default:cactus"]                   = {reverse_spot_default = true,},
    ["default:cactus_brick"]             = {reverse_spot_default = true,},
    ["default:steelblock"]               = {reverse_spot_default = true,},
    ["default:bronzeblock"]              = {reverse_spot_default = true,},
    ["default:copperblock"]              = {reverse_spot_default = true,},
    ["default:diamondblock"]             = {reverse_spot_default = true,},
    ["default:goldblock"]                = {reverse_spot_default = true,},
    ["default:jungletree"]               = {reverse_spot_default = true,},
    ["default:gravel"]                   = {reverse_spot_default = true,},
    ["default:obsidian"]                 = {reverse_spot_default = true,},
    ["default:obsidianbrick"]            = {reverse_spot_default = true,},
    ["seasons:flowing_ice"]              = {reverse_spot_default = true,},
    --MISC
    ["walls:cobble"]                     = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["walls:desertcobble"]               = {reverse_spot_default = false, reverse_seal_default = true}, 
    ["walls:mossycobble"]                = {reverse_spot_default = false, reverse_seal_default = true},
    --Infectable nodes
    ["default:tree"]                     = {infectable_settings = {infected_version = "crop_blight:tree_blighted", chance = 1}},
    ["default:pine_tree"]                = {infectable_settings = {infected_version = "crop_blight:pine_tree_blighted", chance = 1}},
    ["default:acacia_tree"]              = {infectable_settings = {infected_version = "crop_blight:acacia_tree_blighted", chance = 1}},
    ["default:aspen_tree"]               = {infectable_settings = {infected_version = "crop_blight:aspen_tree_blighted", chance = 1}},
    ["default:grass_1"]                  = {infectable_settings = {infected_version = "air", chance = 1}},
    ["default:grass_2"]                  = {infectable_settings = {infected_version = "air", chance = 1}},
    ["farming:wheat_6"]                  = {infectable_settings = {infected_version = "crop_blight:wheat_tall", chance = 1}},
    ["farming:wheat_7"]                  = {infectable_settings = {infected_version = "crop_blight:wheat_tall", chance = 1}},
    ["farming:wheat_8"]                  = {infectable_settings = {infected_version = "crop_blight:wheat_tall", chance = 1}},
    ["farming:soil_wet"]                 = {infectable_settings = {infected_version = "crop_blight:soil_wet_blighted", chance = 1}},
    --["farming:desert_sand_soil_wet"]  = {infectable_settings = {infected_version = "crop_blight:desert_sand_soil_wet_blighted", chance = 1}}, 
}
for name, settings in pairs(crop_blight_settings_by_name) do
    if minetest.registered_nodes[name] then
        minetest.override_item(name, {
            crop_blight_settings = settings
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