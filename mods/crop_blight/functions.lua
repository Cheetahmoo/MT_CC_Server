----------------------------------------------------------------------------
--                            SETTINGS
----------------------------------------------------------------------------
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

--SETTING SEARCH-- Used to see if a registered node has been registered with a specific crop blight setting
local function setting_search(name, crop_blight_setting)
    if minetest.registered_nodes[name] then
        if minetest.registered_nodes[name].crop_blight_settings then
            if minetest.registered_nodes[name].crop_blight_settings[crop_blight_setting] then
                return true
            end
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
        minetest.set_node(chk_pos,{name = "crop_blight:artists_fungus", param2 = wall_direction})
    end
end

--PLACE BLIGHT SPOT-- Controls the placement of blight spots
local function place_blight_spot(pos)
    local under_pos = {x=pos.x, y=pos.y-1, z=pos.z}
    local under_def = minetest.registered_nodes[minetest.get_node(under_pos).name]
    local node = minetest.get_node(pos)
    if under_def then
        local condition_1 = (under_def.drawtype == "normal" and setting_search(under_def.name, "hosts_spot") == false)
        local condition_2 = (not under_def.drawtype == "normal" and setting_search(under_def.name, "hosts_spot") == true)
        if node.name == "air" and (condition_1 or condition_2) then
            minetest.set_node(pos,{name = "crop_blight:blight_spot_"..math.random(1,3), param2 = 1}) --pick one of the 3 spot designs
            return true --Spot placed
        end
        return false --Spot not placed
    end
end

--MAKE REPLACEMENT-- Replaces an Infectable node with its Blighted version
local function make_replacement(pos)
    local node = minetest.get_node(pos)
    local node_name = node.name
    if setting_search(node.name, "infectable_settings") then
        local infected_version = minetest.registered_nodes[node.name].crop_blight_settings.infectable_settings.infected_version 
        if not minetest.registered_nodes[infected_version] then
            minetest.log("error", "node name listed in crop_blight.infectable_settings.infected_version for "..node.name.." does not exist")
            return
        end
        local chance = (1/minetest.registered_nodes[node.name].crop_blight_settings.infectable_settings.chance)
        if chance >= math.random() then
            minetest.set_node(pos,{name = infected_version, param2 = node.param2})
        end
    end
end

--INFECT NEIGHBORS-- Controls spread of infection from Blighted node to Infectable node
local function infect_neighbors(pos)
    local replace_count = 0
    for i = 1, #neighbors do
        local chk_pos  = vector.add(pos, neighbors[i])
        local chk_node = minetest.get_node(chk_pos)
        if setting_search(chk_node.name, "infectable_settings") then --if it is infectable
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
                if chk_light and (chk_light > 0 or chk_node.name == "air") and not setting_search(chk_node.name, "reverse_seal_default") then
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
        path_by_lightlevel(pos, math.random(crop_blight.scatter_dist_min, crop_blight.scatter_dist_max), false), --find by high light level
        path_by_lightlevel(pos, math.random(crop_blight.scatter_dist_min, crop_blight.scatter_dist_max), true),  --find by low light level
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
--ADD BLIGHT HUD-- Adds a dirty image to the player's view when blighted
local function add_blight_hud(player) --FUNCTION SHOULD BE COMMENTED OUT
    if player:get_attribute("crop_blight:hud_id") then
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
        player:set_attribute("crop_blight:hud_id", hud_id)
    end
end

--DEBUG
--REMOVE BLIGHT HUD-- Removes the dirty blight hud when player is no longer contaminated
local function remove_blight_hud(player)--FUNCTION SHOULD BE COMMENTED OUT
    if player:get_attribute("crop_blight:hud_id") then
        local hud_id = player:get_attribute("crop_blight:hud_id")
        player:hud_remove(hud_id)
        player:set_attribute("crop_blight:hud_id", nil)
    else
        return
    end
end
--]]

--BLIGHTED ON DIG-- infects player when blighted node is dug
local function blighted_on_dig(pos, node, player)
    if player:is_player() then
        --minetest.chat_send_player(player:get_player_name(), "you are contaminated") --DEBUG
        player:set_attribute("crop_blight:blight_time", minetest:get_gametime()) --Infects player
        minetest.node_dig(pos, node, player)
        print(dump(node))
        if setting_search(node.name,"scatter_on_dig") then
            if math.random() > 0.75 then
                scatter_blight(pos)
            end
        end
    end
end

--ON PLAYER EXIT-- Called when players dies or leaves the game
local function on_player_exit(player)
    player:set_attribute("crop_blight:blight_time", nil)
    --remove_blight_hud(player) --DEBUG
end


----------------------------------------------------------------------------
--                     REGISTERED CALL-BACKS
----------------------------------------------------------------------------
--BUILD LIST OF CONTAMINATING AND DECONTAMINATING NODES--
local contaminating_nodes   = {}
local decontaminating_nodes = {}
minetest.register_on_mods_loaded(function()
    for name, def in pairs(minetest.registered_nodes) do
        if setting_search(name, "contaminates_player") then
            contaminating_nodes[#contaminating_nodes+1] = name
        elseif setting_search(name, "decontaminates_player") then
            decontaminating_nodes[#decontaminating_nodes+1] = name
        end
    end
end)

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
    if timer < crop_blight.check_interval then
        return
    end
    count = count + 1

    --minetest.chat_send_all("checking for contamination, decontamination, or spread") --DEBUG
    for i, player in ipairs(minetest.get_connected_players()) do --for all players
        local player_pos = player:getpos()
        local infected_status = player:get_attribute("crop_blight:blight_time")
        local near_blight = minetest.find_node_near(player_pos, 1, contaminating_nodes, true) --true means check pos

        --Infect Player
        if near_blight then
            player:set_attribute("crop_blight:blight_time", minetest:get_gametime())
            --add_blight_hud(player) --DEBUG
            --minetest.chat_send_player(player:get_player_name(), "you are contaminated") --DEBUG
            timer = 0
            return --do not want player to spread blight if near blight.
        end

        if infected_status then
            local at_feet  = minetest.get_node(player_pos)
            local under_feet = minetest.get_node({x=player_pos.x, y=player_pos.y-1, z=player_pos.z})
            local infected_time = minetest:get_gametime() - infected_status

            --Decontaminate Player
            if infected_time >= crop_blight.player_blighted_time or has_string(decontaminating_nodes, at_feet.name) or
                    has_string(decontaminating_nodes, under_feet.name) then
                player:set_attribute("crop_blight:blight_time", nil)
                --remove_blight_hud(player) --DEBUG
                --minetest.chat_send_player(player:get_player_name(), "you are clean") --DEBUG
                timer = 0
                return

            --Infect the ground         
            elseif count > crop_blight.player_scatter_interval/crop_blight.check_interval then
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
--                      NODE REGISTRATION
----------------------------------------------------------------------------
--REGISTER BLIGHTED NODES-- 
--This registration function assigns a few poperties by default:
-- 1) will infect infectable neightbors afew seconds after construction
-- 2) will infect the player
-- 3) will infect the player when dug
-- 4) will ocasionally scatter blight (controled by group membership and an ABM)
crop_blight.register_blighted_node = function(name,def)
    def.groups.blighted = 1 --Required group membership
    minetest.register_node(name, {
        description = def.description,
        drawtype = def.drawtype,
        collision_box = def.collision_box,
        node_box = def.node_box,
        waving = def.waving,
        walkable = def.walkable,
        tiles = def.tiles,
        inventory_image = def.inventory_image,
        use_texture_alpha = def.use_texture_alpha,
        special_tiles = def.special_tiles,
        paramtype = def.paramtype,
        paramtype2 = def.paramtype2,
        sunlight_propagates = def.sunlight_propagates,
        walkable = def.walkable,
        pointable = def.pointable,
        buildable_to = def.buildable_to,
        floodable = def.floodable,
        selection_box = def.selection_box,
        is_ground_content = def.is_ground_content,
        drop = def.drop,
        groups = def.groups,
        sounds = def.sounds,
        on_place = def.on_place,
        on_construct = def.on_construct or function(pos)
            minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        end,
        on_timer = def.on_timer or infect_neighbors,
        on_dig = def.on_dig or blighted_on_dig,
        crop_blight_settings = def.crop_blight_settings or {
            contaminates_player = true,
        }
    })
end


----------------------------------------------------------------------------
--                             ABM's
----------------------------------------------------------------------------
--GROUP: BLIGHTED-- Causes blighted nodes to ocasionally spray more blight
minetest.register_abm({
    label = "Reactivate Blighted Nodes",
    nodenames = {"group:blighted"},
    interval = 31,
    chance = 270,
    action = function(pos)
        minetest.get_node_timer(pos):start(math.random(crop_blight.spread_time_min,crop_blight.spread_time_max))
        scatter_blight(pos)
    end,
})