----------------------------------------------------------------------------
--                          BLIGHT SETTINGS
----------------------------------------------------------------------------
--Time it takes for Dry Seed Paste to rot
local rot_max = 600
local rot_min = 400

--How often to check if player is near a contamination node
local check_interval = 4

--Time a player will be infected after contact with a contaminating node
local player_blighted_time = 60

--How often a player scatters blight while infected
local player_scatter_interval = 10

--Distance around a player which might be reached by blight when player is infected
local scatter_dist_max = 8 
local scatter_dist_min = 6

--Time it takes for an infected node to infect its neighbor
local spread_time_max = 10
local spread_time_min = 3

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

--List of nodes which will contaminate a player
--If the "contaminates" setting in the blight_settings for an infectable node is marked "true"
--the blighted version of the infectable node will be automaticly added to this list.
local contaminating_nodes = {
    "oil_separation:blight_spot_1",
    "oil_separation:blight_spot_2",
    "oil_separation:blight_spot_3",
    "oil_separation:artists_fungus",
    "oil_separation:seed_paste_dry_blighted",
    "oil_separation:desert_sand_soil_wet_blighted",
    "oil_separation:soil_wet_blighted",
}

--List of nodes which will decontaminate a player
local decontaminating_nodes = {
    "default:water_source",
    "default:water_flowing",
    "default:meselamp",
}

--Settings for INFECTABLE notes
--Infectable nodes can be added by group or by name. On infection, the blighted node will have 
--a "1 in chance" of converting to "new_node". "blight_settings_by_name" will overwrite 
--"blight_settings_by_group". "New_node" entries where "contaminates" = "true" will be added to
--the "contaminating_nodes" table automaticly.

local blight_settings_by_group = {
    ["flora"]  = {new_node = "default:dry_shrub", chance = 1, contaminates = false},
    ["wheat"]  = {new_node = "oil_separation:wheat_short", chance = 1, contaminates = false},
    ["cotton"] = {new_node = "default:dry_shrub", chance = 3, contaminates = false},
    ["seed"]   = {new_node = "air", chance = 1, contaminates = false},
}

local blight_settings_by_name = {  
    ["default:tree"]          = {new_node = "oil_separation:tree_blighted", chance = 1, contaminates = false},
    ["mt_cc_nodes:bark_ball"] = {new_node = "oil_separation:tree_blighted", chance = 1, contaminates = false},
    ["default:pine_tree"]     = {new_node = "oil_separation:pine_tree_blighted", chance = 1, contaminates = false},
    ["mt_cc_nodes:bark_ball_pine"] = {new_node = "oil_separation:pine_tree_blighted", chance = 1, contaminates = false},
    ["default:acacia_tree"]   = {new_node = "oil_separation:acacia_tree_blighted", chance = 1, contaminates = false},
    ["default:grass_1"]       = {new_node = "air", chance = 1, contaminates = false},
    ["default:grass_2"]       = {new_node = "air", chance = 1, contaminates = false},
    ["farming:wheat_6"]       = {new_node = "oil_separation:wheat_tall", chance = 1, contaminates = false},
    ["farming:wheat_7"]       = {new_node = "oil_separation:wheat_tall", chance = 1, contaminates = false},
    ["farming:wheat_8"]       = {new_node = "oil_separation:wheat_tall", chance = 1, contaminates = false},
    ["farming:soil_wet"]      = {new_node = "oil_separation:soil_wet_blighted", chance = 1, contaminates = true},
    --["farming:desert_sand_soil_wet"]  = {new_node = "oil_separation:desert_sand_soil_wet_blighted", chance = 1, contaminates = true},
    ["oil_separation:seed_paste_dry"] = {new_node = "oil_separation:seed_paste_dry_blighted", chance = 1, contaminates = true},
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
--                      RUN ON MOD START-UP
----------------------------------------------------------------------------
--Combines the settings lists into one table, indexed by node name.
--Creates a numericly indexed list of the infectable nodes.
--Adds "contaminates = true" nodes to contaminating_nodes list.
local blight_settings = {}
local infectable_nodes = {}
for group, settings in pairs(blight_settings_by_group) do
    for name, def in pairs(minetest.registered_nodes) do
        if def.groups[group] then
            blight_settings[name] = settings
            infectable_nodes[#infectable_nodes+1] = name
            if blight_settings[name].contaminates == true then
                contaminating_nodes[#contaminating_nodes+1] = blight_settings[name].new_node
            end
        end
    end
end
for name, settings in pairs(blight_settings_by_name) do
    if minetest.registered_nodes[name] then
        blight_settings[name] = settings
        infectable_nodes[#infectable_nodes+1] = name
        if blight_settings[name].contaminates == true then
            contaminating_nodes[#contaminating_nodes+1] = blight_settings[name].new_node
        end
    end
end


----------------------------------------------------------------------------
--                            FUNCTIONS
----------------------------------------------------------------------------
--ARRAY CONTAINS POSITION-- Used to find if a coordinate position exists in a table
local function has_pos(array, pos)
    for i = 1, #array do
        if array[i].x == pos.x and array[i].y == pos.y and array[i].z == pos.z then
            return true
        end
    end
    return false
end

--ARRAY CONTAINS STRING-- Used to find if a string exists in a table
local function has_string(array, string)
    for i = 1, #array do
        if array[i] == string then 
            return true 
        end
    end
    return false
end

--PLACE TREE FUNGUS-- Controls how shelf fungus is placed on rotted trees
local function place_artists_fungus(pos) --pos is tree node
    local chk_pos = vector.add(pos, neighbors[math.random(1,4)]) --pick random side of tree node
    local chk_node = minetest.get_node(chk_pos)
    if chk_node.name == "air" then
        local wall_direction = minetest.dir_to_wallmounted(vector.subtract(pos, chk_pos))
        minetest.set_node(chk_pos,{name = "oil_separation:artists_fungus", param2 = wall_direction})
    end
end

--PLACE BLIGHT SPOT-- Controls the placement of blight spots
local function place_blight_spot(pos)
    local under_pos = {x=pos.x, y=pos.y-1, z=pos.z}
    local under_def = minetest.registered_nodes[minetest.get_node(under_pos).name]
    local node = minetest.get_node(pos)
    if under_def and not has_string(no_blight_spot_nodes, under_def.name) and under_def.drawtype == "normal" and node.name == "air" then
        minetest.set_node(pos,{name = "oil_separation:blight_spot_"..math.random(1,3), param2 = 1}) --pick one of the 3 spot designs
        return true --Spot placed
    end
    return false --Spot not placed
end

--MAKE REPLACEMENT-- Replaces an Infectable node with its Blighted version
local function make_replacement(pos)
    local node = minetest.get_node(pos)
    local node_name = node.name
    if blight_settings[node_name] then
        local node_blighted = blight_settings[node_name].new_node 
        if not minetest.registered_nodes[node_blighted] then
            return
        end
        local chance = (1/blight_settings[node_name].chance)
        if chance >= math.random() then
            minetest.set_node(pos,{name = node_blighted, param2 = node.param2})
        end
    end
end

--INFECT NEIGHBORS-- Controls spread of infection from Blighted node to Infectable node
local function infect_neighbors(pos)
    local replace_count = 0
    for i = 1, #neighbors do
        local chk_pos  = vector.add(pos, neighbors[i])
        local chk_node = minetest.get_node(chk_pos)
        if blight_settings[chk_node.name] then --if it has a blighted version
            make_replacement(chk_pos)
            replace_count = replace_count+1
        end
        if i == 6 and replace_count > 1 then --do not loop through extended neighbors if replacements have been made.
            break
        end
    end
    return false
end

--PATH BY LIGHTLEVEL-- Finds a path from "pos" to a node "dist" nodes a way based on light level.
local function path_by_lightlevel(pos, max_dist, low_bool)
    --Initiate variables
    pos = vector.round(pos)
    local current_dist = 0
    local current_pos = pos
    local found_nodes = {pos}
    local trend_dir = math.random(1,4) --Randomly pick starting cardinal direction of travel

    while current_dist < max_dist do       
        local possible_pos = {}
        local current_light = 0
        if low_bool then --If seeking darkest area, current_light level should start at max light level
            current_light = 15
        end
        
        for i = 1, 6 do --first 6 neighbors
            local chk_pos = vector.add(current_pos, neighbors[i])
            if not has_pos(found_nodes, chk_pos) then
                local chk_node = minetest.get_node(chk_pos)
                local chk_light = minetest.get_node_light(chk_pos)
                if chk_light and (chk_light > 0 or chk_node.name == "air") and not has_string(airtight_translucent_nodes, chk_node.name) then
                    if (low_bool and chk_light < current_light) or (not low_bool and chk_light > current_light) then
                        possible_pos = {} --If light level is highest/lowest, make chk pos the only entry on the list
                        possible_pos[i] = chk_pos
                        current_light = chk_light
                    elseif chk_light == current_light then
                        possible_pos[i] = chk_pos
                    end
                end
            end
        end
        
        --Build Priority Table
        local sides = {1, 2, 3, 4} --Scramble side index numbers --RANDOMIZATION PROBABLY NOT NECESSARY
        for i = #sides, 2, -1 do
            local j = math.random(i)
            sides[i], sides[j] = sides[j], sides[i]
        end
        local priority = {5, trend_dir, 6, sides[1], sides[2], sides[3], sides[4]} -- down, then trend direction, then up, then random direction

        --Choose Next Position
        local next_pos = {}
        for i = 1, #priority do
            if possible_pos[priority[i]] then
                next_pos[1] = possible_pos[priority[i]]
                --minetest.set_node(next_pos[1], {name = "default:glass"}) --DEBUG
                if priority[i] > 0 and priority[i] < 5 then
                    trend_dir = priority[i] --Set trend direction when the next position is to a side.
                end
                break
            end
        end

        --Prepare for next iteration or break
        if next_pos[1] then
            current_pos = next_pos[1]
            current_dist = current_dist + 1
            found_nodes[#found_nodes+1] = next_pos[1]
        else
            break
        end
    end
    return current_pos
end

--SCATTER BLIGHT-- Spreads blight through the air. 
local function scatter_blight(pos)
    local blight_pos = {
        path_by_lightlevel(pos, math.random(scatter_dist_min, scatter_dist_max), false), --find by high light level
        path_by_lightlevel(pos, math.random(scatter_dist_min, scatter_dist_max), true),  --find by low light level
    }
    for i = 1, #blight_pos do
        --minetest.set_node(blight_pos[i],{name = "default:obsidian_glass"})
        infect_neighbors(blight_pos[i])
        for j = 1, 6 do --first 6 neighbors
            local chk_pos = vector.add(blight_pos[i], neighbors[j])
            if place_blight_spot(chk_pos) then
                break
            end
        end
    end
end
--[[DEBUG
local function add_blight_hud(player) --FUNCTION SHOULD BE COMMENTED OUT
    if player:get_attribute("oil_separation:hud_id") then
        return
    else
        local hud_id = player:hud_add({
            hud_elem_type = "image",
            alignment = {x=1, y=1},
            scale = {
                x = -100,
                y = -100
            },
            text = "oil_separation_blighted_hud.png"
        })
        player:set_attribute("oil_separation:hud_id", hud_id)
    end
end

--DEBUG
local function remove_blight_hud(player)--FUNCTION SHOULD BE COMMENTED OUT
    if player:get_attribute("oil_separation:hud_id") then
        local hud_id = player:get_attribute("oil_separation:hud_id")
        player:hud_remove(hud_id)
        player:set_attribute("oil_separation:hud_id", nil)
    else
        return
    end
end
--]]

--BLIGHTED ON DIG-- infects player when blighted node is dug
local function blighted_on_dig(pos, node, player)
    if player:is_player() then
        player:set_attribute("oil_separation:blight_time", minetest:get_gametime()) --Infects player
        minetest.node_dig(pos, node, player)
    end
end

--ON PLAYER EXIT-- Called when players dies or leaves the game
local function on_player_exit(player)
    player:set_attribute("oil_separation:blight_time", nil)
    --remove_blight_hud(player)
end

----------------------------------------------------------------------------
--                     REGISTERED CALL-BACKS
----------------------------------------------------------------------------

--REMOVE BLIGHTED STATUS FROM PLAYER ON RESIGNATION OR DEATH--
minetest.register_on_leaveplayer(function(player)
    on_player_exit(player)
end)
minetest.register_on_dieplayer(function(player)
    on_player_exit(player)
end)

--PLAYER DYNAMICS-- Contaminate player, Decontaminate player, or cause player to spread blight
local timer = 0
local count = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < check_interval then
        return
    end
    count = count + 1

    --minetest.chat_send_all("checking for contamination, decontamination, or spread") --DEBUG
    for i, player in ipairs(minetest.get_connected_players()) do --for all players
        local player_pos = player:getpos()
        local infected_status = player:get_attribute("oil_separation:blight_time")
        local near_blight = minetest.find_node_near(player_pos, 1, contaminating_nodes, true) --true means check pos

        --Infect Player
        if near_blight then
            player:set_attribute("oil_separation:blight_time", minetest:get_gametime())
            --add_blight_hud(player) --DEBUG
            --minetest.chat_send_player(player:get_player_name(), "you are contaminated") --DEBUG
            timer = 0
            return --do not want player to spread blight if neat blight.
        end

        if infected_status then
            local at_feet  = minetest.get_node(player_pos)
            local under_feet = minetest.get_node({x=player_pos.x, y=player_pos.y-1, z=player_pos.z})
            local infected_time = minetest:get_gametime() - infected_status

            --Decontaminate Player
            if infected_time >= player_blighted_time or has_string(decontaminating_nodes, at_feet.name) or
                    has_string(decontaminating_nodes, under_feet.name) then
                player:set_attribute("oil_separation:blight_time", nil)
                --remove_blight_hud(player) --DEBUG
                --minetest.chat_send_player(player:get_player_name(), "you are clean") --DEBUG
                timer = 0
                return

            --Infect the ground         
            elseif count > player_scatter_interval/check_interval then
                scatter_blight(player_pos)
                timer = 0
                count = 0
                return
            end
        end
    end
    timer = 0
end)

----------------------------------------------------------------------------
--                      NODE REGISTRATIONS
----------------------------------------------------------------------------
--REGISTER BLIGHTED NODES-- Nodes registered using register_blighted_node will blight infectable nodes.
local function register_blighted_node(name,def)
    def.groups.blighted = 1 --Required group membership
    minetest.register_node("oil_separation:"..name, {
        description = def.description,
        drawtype = def.drawtype,
        collision_box = def.collision_box,
        nodebox = def.nodebox,
        waving = def.waving,
        walkable = def.walkable,
        tiles = def.tiles,
        special_tiles = def.special_tiles,
        paramtype = def.paramtype,
        paramtype2 = def.paramtype2,
        sunlight_propagates = def.sunlight_propagates,
        walkable = def.walkable,
        buildable_to = def.buildable_to,
        selection_box = def.selection_box,
        is_ground_content = def.is_ground_content,
        drop = def.drop,
        groups = def.groups,
        sounds = def.sounds,
        on_place = def.on_place,
        on_construct = def.on_construct,
        on_timer = def.on_timer or infect_neighbors,
        on_dig = def.on_dig or blighted_on_dig,
    })
end

--Blighted Dry Seed Paste
register_blighted_node("seed_paste_dry_blighted", {
	description = "Blighted Dry Seed Paste",
    drop = "oil_separation:seed_paste_dry",
    tiles = {"oil_separation_seed_paste_dry.png^oil_separation_tree_blight.png"},
    groups = {crumbly = 3, falling_node = 1, not_in_creative_inventory = 1, flammable = 1, waste = 1},
    sounds = default.node_sound_sand_defaults(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
    end,
})

--Blighted Soil Wet
register_blighted_node("soil_wet_blighted", {
	description = "Blighted Wet Soil",
    drop = {
        max_items = 1,
        items = {
            {items = {"flowers:mushroom_spores_red"}, rarity = 5}, 
            {items = {"default:dirt"}}
        }
    },
    tiles = {
        "default_dirt.png^farming_soil_wet.png", --^oil_separation_farm_top.png",
        "default_dirt.png^farming_soil_wet_side.png^oil_separation_farm_side.png",
    },
    groups = {crumbly = 3, not_in_creative_inventory = 1, soil=3, grassland = 1, farming_soil = 1},
    sounds = default.node_sound_dirt_defaults(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
    end,
    on_dig = function(pos, node, player) --Scatters blight on dig
        minetest.node_dig(pos, node, player)
        if math.random() > 0.75 then
            scatter_blight(pos)
        end
    end,
})

--Blighted Desert Sand Soil Wet
register_blighted_node("desert_sand_soil_wet_blighted", {
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
        "farming_desert_sand_soil_wet_side.png^oil_separation_farm_side.png"
    },
    groups = {crumbly = 3, not_in_creative_inventory = 1, soil=3, desert = 1},
    sounds = default.node_sound_sand_defaults(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
    end,
    on_dig = function(pos, node, player) --Scatters blight on dig
        minetest.node_dig(pos, node, player)
        if math.random() > 0.75 then
            scatter_blight(pos)
        end
    end,
})

local hollow_tree = {
    {-0.5, -0.5, -0.5, -0.35, 0.5, 0.5},
    {0.35, -0.5, -0.5, 0.5, 0.5, 0.5},
    {-0.5, -0.5, 0.35, 0.5, 0.5, 0.5},
    {-0.5, -0.5, -0.5, 0.5, 0.5, -0.35},
}

--Blighted Tree
register_blighted_node("tree_blighted", {
    description = "Blighted Tree",
    drawtype = "nodebox",
    nodebox = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_tree_top.png^oil_separation_tree_hole_1.png", 
        "default_tree_top.png^oil_separation_tree_hole_1.png",
        "default_tree.png^oil_separation_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1, blighted_tree = 1},
    drop = 'default:wood',
    sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
        if math.random() < 1/5 then --one in 5 chance of setting artist's fungus
            minetest.after(math.random(1,5), function(pos)
                place_artists_fungus(pos)
            end, pos)
        end
    end,
})

--Blighted Pine Tree
register_blighted_node("pine_tree_blighted", {
    description = "Blighted Pine Tree",
    drawtype = "nodebox",
    nodebox = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_pine_tree_top.png^oil_separation_tree_hole_2.png", 
        "default_pine_tree_top.png^oil_separation_tree_hole_2.png", 
        "default_pine_tree.png^oil_separation_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1, blighted_tree = 1},
    drop = 'default:pine_wood',
	sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
        if math.random() < 1/5 then
            place_artists_fungus(pos)
        end
    end,
})

--Blighted Acacia Tree
register_blighted_node("acacia_tree_blighted", {
    description = "Blighted Acacia Tree",
    drawtype = "nodebox",
    nodebox = {type = "regular"},
    collision_box = {
		type = "fixed",
		fixed = hollow_tree
	},
    tiles = {
        "default_acacia_tree_top.png^oil_separation_tree_hole_2.png", 
        "default_acacia_tree_top.png^oil_separation_tree_hole_2.png", 
        "default_acacia_tree.png^oil_separation_tree_blight.png",
    },
	paramtype2 = "facedir",
	is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 1, flammable = 2, not_in_creative_inventory = 1, blighted_tree = 1},
    drop = 'default:acacia_wood',
	sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
        if math.random() < 1/8 then
            place_artists_fungus(pos)
        end
    end,
})

--Blighted Wheat short
register_blighted_node("wheat_short", {
    description = "Blighted Wheat",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"oil_separation_wheat_short.png"},
    paramtype = "light",
    paramtype2 = "meshoptions",
    drop = "default:dry_shrub",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1, not_in_creative_inventory = 1, replaced_by_snow = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
    end,
})

--Blighted Wheat Tall
register_blighted_node("wheat_tall", {
    description = "Blighted Wheat",
	drawtype = "plantlike",
	waving = 1,
	tiles = {"oil_separation_wheat_tall.png"},
    paramtype = "light",
    paramtype2 = "meshoptions",
    drop = "default:dry_shrub",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1, not_in_creative_inventory = 1, replaced_by_snow = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
    end,
})

--Blight Spot --
for i = 1, 3 do
    minetest.register_node("oil_separation:blight_spot_"..i, {
        description = "Blight",
        drop = "",
        tiles = {"oil_separation_blight_spot_"..i..".png"},
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
minetest.register_node("oil_separation:artists_fungus", {
	description = "Artists Fungus",
	tiles = { --node box is defined so that fungus is laying on its back in 'normal' position. Wallmounted puts it correctly on the tree
        "oil_separation_artists_fungus_front.png", -- front of fungus
        "oil_separation_artists_fungus_back.png",  -- back of fungus
        "oil_separation_artists_fungus_left.png",  -- left of fungus
        "oil_separation_artists_fungus_right.png", -- right of fungus
        "oil_separation_artists_fungus_top.png",   -- top of fungus
        "oil_separation_artists_fungus_bot.png",   -- bottom of fungus
    },
	inventory_image = "oil_separation_artists_fungus_front.png",
	wield_image = "oil_separation_artists_fungus_front.png",
	drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    drop = "flowers:mushroom_brown",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, not_in_creative_inventory=1, attached_node=1},
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
            place_item:set_name("oil_separation:artists_fungus")
        end
        minetest.item_place(place_item, placer, pointed_thing, wallmounted)
        itemstack:set_name("oil_separation:artists_fungus")
        return itemstack
    end,
})


----------------------------------------------------------------------------
--                         NODE OVERRIDEs
----------------------------------------------------------------------------
--OVERRIDE SEED PASTE DRY--
minetest.override_item("oil_separation:seed_paste_dry", {
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(rot_min,rot_max))
    end,
    on_timer = function(pos)
        minetest.set_node(pos,{name = "oil_separation:seed_paste_dry_blighted"})
    end
}) 

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
                    minetest.sound_play("oil_separation_sweeper",
                        {
                            pos = pointed_thing.above,
                            gain = 0.5,
                            max_hear_distance = 5,
                            loop = false,
                        }
                    )
                end
            end
        end,
    })
end


----------------------------------------------------------------------------
--                             ABM's
----------------------------------------------------------------------------
--GROUP: BLIGHTED--
minetest.register_abm({
    label = "Reactivate Blighted Nodes",
    nodenames = {"group:blighted"},
    interval = 31,
    chance = 300,
    action = function(pos)
        minetest.get_node_timer(pos):start(math.random(spread_time_min,spread_time_max))
        scatter_blight(pos)
    end,
})

--NODE: BLIGHTED WASTE TO DIRT-- Gives some reason to play with blighted material
minetest.register_abm({
    label = "Blighted Waste to Dirt",
	nodenames = {"oil_separation:seed_paste_dry_blighted"},
	interval = 21,
    chance = 150,
    catch_up = true,
	action = function(pos)
		local above_pos = {x=pos.x, y=pos.y+1, z=pos.z}
		local above_lit = minetest.get_node_light(above_pos)
        if above_lit > 14 then --must be under sun
            minetest.set_node(pos,{name = "default:dirt"})
		end
	end,
})