----------------------------------------------------------------------------
--                            MOD SETTINGS
----------------------------------------------------------------------------
--Establish Strainer name space
strainer = {}

--Number of nodes below strainer searched before placing output
local drop_dist = 10

--Number of uses before strainer breaks
local min_uses = 8
local max_uses = 10

--How often the environment is checked for changes (This is the ABM interval). 
local update_freq = 3 


----------------------------------------------------------------------------
--                            FUNCTIONS
----------------------------------------------------------------------------
--REPLACEABLE BOOL-- indicates if a node can be replaced by strainer output
local function replaceable_bool(pos)
    local node = minetest.get_node(pos)
    if minetest.registered_nodes[node.name] then
        local node_def = minetest.registered_nodes[node.name]
        --output can replace air and nodes which are buildable_to = true, but not liquid sources
        if node.name == "air" or (node_def.buildable_to and node_def.liquidtype ~= "source") then
            return true
        end
    end
    return false
end

--BREAK STRAINER--
local function break_strainer(pos)
    minetest.sound_play("strainer_tear",{
        gain = 0.5,
        max_hear_distance = 10,
        loop = false,
        pos = pos,
    })
    minetest.set_node(pos, {name = "strainer:strainer_cloth_broken"})
    minetest.check_for_falling({x=pos.x, y=pos.y+1, z=pos.z}) --blocks automaticly fall through strainer on break
end

--FIND SOLID GROUND-- returns the position of the nearest solid ground below a given position or drop_dist
local function find_solid_ground(pos)
    for i = 1, drop_dist do
        local chk_pos = vector.add(pos, {x=0,y=-i,z=0})
        if i >= drop_dist or replaceable_bool(chk_pos) ~= true then 
            return chk_pos
        end
    end
end

--EMPTY STRAINER ON TIMER-- Empty strainer checks if it should become active
local function empty_on_timer(pos)
    local above_node = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
    if minetest.registered_nodes[above_node.name] and minetest.registered_nodes[above_node.name].strainer_settings then
        local strain_time = minetest.registered_nodes[above_node.name].strainer_settings.strain_time
        minetest.swap_node(pos,{name ="strainer:strainer_cloth_active"})
        minetest.get_node_timer(pos):set(strain_time,0)
        return
    end
    return true
end

--ACTIVE STRAINER ON TIMER-- Places output below strainer and replaces above node with residual
local function active_on_timer(pos)
    local above_pos  = {x=pos.x, y=pos.y+1, z=pos.z}
    local above_node = minetest.get_node(above_pos)

    --Is above node strianable?
    if not minetest.registered_nodes[above_node.name] or not minetest.registered_nodes[above_node.name].strainer_settings then
        minetest.swap_node(pos,{name = "strainer:strainer_cloth"})
        minetest.get_node_timer(pos):set(update_freq, 0)
        return
    end
    
    --Can below node accept output?
    local below_pos = {x=pos.x, y=pos.y-1, z=pos.z}
    if not replaceable_bool(below_pos) then
        return true --Do nothing but restart timer
    end

    --Chose Residual
    local residual
    if minetest.registered_nodes[above_node.name].strainer_settings.alt_residual then 
        --if an alternate residual is listed, run function which determines if alternate should be used
        if minetest.registered_nodes[above_node.name].strainer_settings.do_alt_residual_bool(above_pos) then
            residual = minetest.registered_nodes[above_node.name].strainer_settings.alt_residual
        else
            residual = minetest.registered_nodes[above_node.name].strainer_settings.residual
        end
    else
        residual = minetest.registered_nodes[above_node.name].strainer_settings.residual
    end

    --Chose Output
    local output
    if minetest.registered_nodes[above_node.name].strainer_settings.alt_output then 
        --if an alternate output is listed, run function which determines if alternate should be used
        if minetest.registered_nodes[above_node.name].strainer_settings.do_alt_output_bool(above_pos) then
            output = minetest.registered_nodes[above_node.name].strainer_settings.alt_output
        else
            output = minetest.registered_nodes[above_node.name].strainer_settings.output
        end
    else
        output = minetest.registered_nodes[above_node.name].strainer_settings.output
    end

    --Place residual node or item
    if minetest.registered_nodes[residual] then
        minetest.set_node(above_pos,{name = residual})
    elseif minetest.registered_items[residual] then
        minetest.remove_node(above_pos)
        minetest.add_item(above_pos,{name = residual})
    else
        minetest.log("error", "node/item name listed in strainer_settings.residual for "..above_node.name.." does not exist")
    end

    --Place output node or item
    local output_pos = vector.add(find_solid_ground(pos), {x=0, y=1, z=0}) --place on top of solid node
    if minetest.registered_nodes[output] then
        minetest.set_node(output_pos,{name = output})
    elseif minetest.registered_items[output] then
        minetest.add_item(output_pos,{name = output})
    else
        minetest.log("error", "node/item name listed in strainer_settings.output for "..above_node.name.." does not exist")
    end

    --Should strainer break?
    local pos_meta = minetest.get_meta(pos)
    local current_use_count = pos_meta:get_int("current_use_count")
    local unique_use_max = pos_meta:get_int("unique_use_max")
    if current_use_count >= unique_use_max then
        break_strainer(pos)
        return
    end

    --Advance use count
    pos_meta:set_int("current_use_count", current_use_count+1)
    return true --Restarts timer. Needed when residual is strainable.
end

--STRAINER ON DIG-- If the strainer has been used, return a broken strainer
local function strainer_on_dig(pos, node, player)
    if player:is_player() then
        local current_use_count = minetest.get_meta(pos):get_int("current_use_count")
        local inv = player:get_inventory()
        local return_item
        if current_use_count > 0 then
            return_item = "strainer:strainer_cloth_broken"
            minetest.sound_play("strainer_tear",{
                gain = 0.5,
                max_hear_distance = 10,
                loop = false,
                pos = pos,
            })
        else
            return_item = "strainer:strainer_cloth"
        end
        if inv:room_for_item("main", {name = return_item}) then
            inv:add_item("main", {name = return_item})
            minetest.remove_node(pos)
            print("place "..return_item.." in "..player:get_player_name().."'s Inventory")
        else
            minetest.remove_node(pos)
            minetest.add_item(pos, {name = return_item})
            print("place "..return_item.." on ground near "..player:get_player_name())
        end
    end
end

----------------------------------------------------------------------------
--                      NODE REGISTRATION 
----------------------------------------------------------------------------

--Shape of Strainer
local strainer_nodebox = {
    type = "fixed",
    fixed = {
        {-0.5, 0.375, -0.5, 0.5, 0.4375, 0.5},
        {-0.5, -0.125, -0.5, -0.375, 0.5, 0.5},
        {0.375, -0.125, -0.5, 0.5, 0.5, 0.5},
        {-0.5, -0.125, -0.5, 0.5, 0.5, -0.375},
        {-0.5, -0.125, 0.375, 0.5, 0.5, 0.5},
        {-0.5, 0, -0.5, 0.5, 0.125, 0.5},
    }
}
local strainer_selection_box = {
    type = "fixed",
    fixed = {
        {-0.5, -0.125, -0.5, 0.5, 0.5, 0.5},
    }
}

--Cloth Strainer
minetest.register_node("strainer:strainer_cloth", {
	description = "Cloth Strainer",
	tiles = {
        "strainer_strainer_cloth_top.png", 
        "strainer_strainer_cloth_bot.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_fb.png",
        "strainer_strainer_cloth_fb.png",
    },
	inventory_image = "strainer_strainer_cloth_top.png",
	wield_image = "strainer_strainer_cloth_top.png",
    drawtype = "nodebox",
    paramtype = "light",
	walkable = true,
    buildable_to = false,
    sounds = default.node_sound_wood_defaults(),
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, catches_oil = 1},
    node_box = strainer_nodebox,
    selection_box = strainer_selection_box,
    on_construct = function(pos)
        minetest.get_meta(pos):set_int("unique_use_max", math.random(min_uses, max_uses)) --assigns number of uses before breaking
        minetest.get_node_timer(pos):set(update_freq,0)
    end,
    on_dig = strainer_on_dig,
    on_timer = empty_on_timer,
})

--Active Version
minetest.register_node("strainer:strainer_cloth_active", {
	description = "Active Cloth Strainer",
	tiles = {
        "strainer_strainer_cloth_top.png", 
        "strainer_strainer_cloth_bot_active.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_fb.png",
        "strainer_strainer_cloth_fb.png",
    },
	inventory_image = "strainer_strainer_cloth_top.png",
	wield_image = "strainer_strainer_cloth_top.png",
    drawtype = "nodebox",
    paramtype = "light",
	walkable = true,
    buildable_to = false,
    sounds = default.node_sound_wood_defaults(),
    drop = "strainer:strainer_cloth_broken",
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, not_in_creative_inventory = 1, catches_oil = 1},
    node_box = strainer_nodebox,
    selection_box = strainer_selection_box,
    on_timer = active_on_timer,
})

--Broken Version
minetest.register_node("strainer:strainer_cloth_broken", {
	description = "Broken Cloth Strainer",
	tiles = {
        "strainer_strainer_cloth_broken_top.png", 
        "strainer_strainer_cloth_broken_bot.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_lside.png",
        "strainer_strainer_cloth_fb.png",
        "strainer_strainer_cloth_fb.png",
    },
	inventory_image = "strainer_strainer_cloth_broken_top.png",
	wield_image = "strainer_strainer_cloth_broken_top.png",
    drawtype = "nodebox",
    paramtype = "light",
	walkable = false,
    buildable_to = false,
    floodable = true,
    on_flood = function(pos,oldnode,newnode)
        minetest.remove_node(pos)
        minetest.add_item(pos,"strainer:strainer_cloth_broken")
    end,
    sounds = default.node_sound_wood_defaults(),
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1, not_in_creative_inventory = 1},
    node_box = strainer_nodebox,
    selection_box = strainer_selection_box,
})

minetest.register_craft({
	output = "strainer:strainer_cloth",
	recipe = {
		{"group:wool", "group:wood", "group:wool"},
		{"group:wood", "group:wool", "group:wood"},
		{"group:wool", "group:wood", "group:wool"},
	}
})


----------------------------------------------------------------------------
--                          OVERRIDES 
----------------------------------------------------------------------------
--ADD GROUP AND SETTING INFORMATION USING OVERRIDE--
strainer.strainable_override = function(name, strainer_settings)
    local override_groups = minetest.registered_nodes[name].groups
    override_groups["strainable"] = 1
    minetest.override_item(name, {
        groups = override_groups,
        strainer_settings = strainer_settings, --Four settings required: output, residual, strain_time, and drip_color
    })
end

strainer.strainable_override("default:water_source",{
    output = "default:water_source", --(REQUIRED)
    --alt_output = placeholder
    --do_alt_output_bool = placeholder
    residual = "air",                --(REQUIRED)
    --alt_residual = placeholder
    --do_alt_residual_bool = placeholder
    strain_time = 10,                --(REQUIRED)
    drip_color = "blue",             --(REQUIRED)
})

strainer.strainable_override("default:river_water_source",{
    output = "default:river_water_source", --(REQUIRED)
    --alt_output = placeholder
    --do_alt_output_bool = placeholder
    residual = "air",                --(REQUIRED)
    --alt_residual = placeholder
    --do_alt_residual_bool = placeholder
    strain_time = 10,                --(REQUIRED)
    drip_color = "blue",             --(REQUIRED)
})

----------------------------------------------------------------------------
--                              ABM's
----------------------------------------------------------------------------
--ACTIVE STRAINER-- Places particles for an active strainer deactivates the strainer
minetest.register_abm({
    label = "Activate Strainer-Add Drips",
    nodenames = {"strainer:strainer_cloth_active"},
	interval = update_freq,
	chance = 1,
    action = function(pos)
        local above_pos  = {x=pos.x, y=pos.y+1, z=pos.z}
        local above_node = minetest.get_node(above_pos)
        if minetest.registered_nodes[above_node.name] and minetest.registered_nodes[above_node.name].strainer_settings then
            local drip_color = minetest.registered_nodes[above_node.name].strainer_settings.drip_color
            minetest.add_particlespawner({
                amount = 12,
                time = update_freq*2,
                minpos = vector.add(pos, {x=-0.5,y=-0.6,z=-0.5}),
                maxpos = vector.add(pos, {x= 0.5,y=-0.6,z= 0.5}),
                minvel = {x = 0, y = -1.0, z = 0},
                maxvel = {x = 0, y = -1.2, z = 0},
                minacc = {x = 0, y = -2, z = 0},
                maxacc = {x = 0, y = -2, z = 0},
                minexptime = 3,
                maxexptime = 3,
                minsize = 1,
                maxsize = 2.5,
                vertical = true,
                collisiondetection = true,
                collision_removal = true,
                texture = "strainer_drip.png^[colorize:"..drip_color..":50",
            })
            local splatter_pos = find_solid_ground(pos)
            if drop_dist > (pos.y - splatter_pos.y) then --splatter should not form in air if max check dist has been reached.
                minetest.add_particlespawner({
                    amount = 10,
                    time = update_freq*2,
                    minpos = vector.add(splatter_pos, {x=-0.5,y= 0.6,z=-0.5}),
                    maxpos = vector.add(splatter_pos, {x= 0.5,y= 0.6,z= 0.5}),
                    minvel = {x =-2.5, y = 1, z =-2.5},
                    maxvel = {x = 2.5, y = 3, z = 2.5},
                    minacc = {x = 0, y =-3, z = 0},
                    maxacc = {x = 0, y =-3, z = 0},
                    minexptime = 0.03,
                    maxexptime = 0.05,
                    minsize = 2.5,
                    maxsize = 4,
                    vertical = false,
                    texture = "strainer_splash.png^[colorize:"..drip_color..":50",
                })
            end
        else
            minetest.swap_node(pos,{name = "strainer:strainer_cloth"})
            minetest.get_node_timer(pos):set(update_freq, 0)
        end
    end,
})


----------------------------------------------------------------------------
--                              SOUND
----------------------------------------------------------------------------
local sound_handles = {}
local timer = 0
local search_min  = {x=-3, y=1, z=-3} -- minimum corner of search area
local search_max  = {x= 3, y=drop_dist, z= 3} -- maximum corner of search area

-- Update sound for player
local function update_player_sound(player)
    --Stop previous sound
    local player_name = player:get_player_name()
    if sound_handles[player_name] then
        minetest.sound_stop(sound_handles[player_name])
        sound_handles[player_name] = nil
    end

    --Search for active strainers above player
    local player_pos = player:get_pos()
    local area_min = vector.add(player_pos, search_min)
    local area_max = vector.add(player_pos, search_max)
    local strainer_pos = minetest.find_nodes_in_area(area_min, area_max, "strainer:strainer_cloth_active")

    if #strainer_pos > 0 then
        --Calculate sound center
        local sum_vector = {x=0,y=0,z=0}
        for i = 1, #strainer_pos do
            sum_vector = vector.add(sum_vector, strainer_pos[i])
        end
        local center_pos = find_solid_ground(vector.divide(sum_vector,#strainer_pos)) --finds center of active strainers and then finds where drips hit floor

        --Determine if few or many drips should be played
        local sound
        if #strainer_pos > 12 then
            sound = "strainer_dripping_large"
        else
            sound = "strainer_dripping_small"
        end

        --Play sound
        local handle = minetest.sound_play(sound,{
            pos = center_pos,
            to_player = player_name,
            gain = 0.5,
            max_hear_distance = 5,
            loop = true,
        })
        -- Store sound handle for this player
        if handle then
            sound_handles[player_name] = handle
        end
    end
end

--Update sound on global step
local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < update_freq then
        return
    end

    timer = 0
    local players = minetest.get_connected_players()
    for i = 1, #players do
        update_player_sound(players[i])
    end
end)

--Stop sound and clear sound when player leaves game
minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    if sound_handles[player_name] then
        minetest.sound_stop(sound_handles[player_name])
        sound_handles[player_name] = nil
    end
end)