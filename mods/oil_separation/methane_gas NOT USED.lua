----------------------------------------------------------------------------
--                            SETTINGS
----------------------------------------------------------------------------

--GAS PARAMETERS--
local gas_gen_int    = 20  --Interval for gas generating ABM
local gas_gen_chance = 1   --Chance for gas generating ABM
local gas_to_gasless = 600 --Length of time a dry node will produce gas
local gas_spread_max = 3   --Time in seconds it takes for a gas node to move
local gas_spread_min = 2
local thrive_radius  = 3   --Defines the area around support nodes inwhich gas will not be killed by air

--NODE NAMES--
local lp_gas  = "oil_separation:methane_gas_lp"  --Low Presure gas name
local hp_gas  = "oil_separation:methane_gas_hp"  --High Presure gas name

local gas_gen = { --Nodes which produce gas
    "oil_separation:seed_paste_dry",
}

local gas_support = { --Nodes which keep gas alive if gas is touching air
    "oil_separation:seed_paste_oily",
    "oil_separation:seed_paste_dry",
    "oil_separation:seed_paste_gasless",
}

--List of nodes or node groups through which gas should be able to pass
local pass_through = { 
    "group:leaves",
    "group:sapling",
    "group:grass",
    "group:dry_grass",
    "group:flora",
    "group:rail",
    "group:flower",
    "group:soil",
    "group:sand",
    "group:liquid",
    "doors:trapdoor_steel_open",
    "doors:trapdoor_open",
    "fire:basic_flame",
    "strainer:strainer_cloth",
    "strainer:strainer_cloth_broken",
}

--List of nodes or node groups which ignite gas
local gas_igniter = { 
    "fire:basic_flame",
    "group:lava",
    "group:torch",
    "walking_light:light",
    "moreblocks:super_glow_glass",
    "moreblocks:glow_glass",
    "lantern:lantern",
}

--DEFINE NEIGHBORS--
local neighbors = { --Positions to add to get the nodes around the current node
    {x= 1,y= 0,z= 0}, --East   (1)
    {x=-1,y= 0,z= 0}, --West   (2)
    {x= 0,y= 0,z= 1}, --North  (3)
    {x= 0,y= 0,z=-1}, --South  (4)
    {x= 0,y=-1,z= 0}, --Under  (5)
    {x= 0,y= 1,z= 0}, --Above  (6)
    --Extended--
    {x= 1,y= 1,z= 1}, --E Top N (7)
    {x=-1,y= 1,z= 1}, --W Top N (8)
    {x= 1,y= 1,z=-1}, --E Top S (9)
    {x=-1,y= 1,z=-1}, --W Top S (10)
    {x= 1,y=-1,z= 1}, --E Bot N (11)
    {x=-1,y=-1,z= 1}, --W Bot N (12)
    {x= 1,y=-1,z=-1}, --E Bot S (13)
    {x=-1,y=-1,z=-1}, --W Bot S (14)
}

--DEFINE FIREBALL SHAPE--
local fireball = {
      --epicenter--
    {x= 0,y= 0,z= 0},
    {x= 1,y= 0,z= 0},
    {x=-1,y= 0,z= 0},
    {x= 0,y= 0,z= 1},
    {x= 0,y= 0,z=-1},
    {x= 0,y=-1,z= 0},
       --shaft--
    {x= 0,y= 1,z= 0},
    {x= 0,y= 2,z= 0},
    {x= 0,y= 3,z= 0},
    {x= 0,y= 4,z= 0},
    {x= 0,y= 5,z= 0},
    {x= 0,y= 6,z= 0},
}

----------------------------------------------------------------------------
--                       RUN AT MOD LOAD
----------------------------------------------------------------------------

--ARRAY CONTAINS STRING-- Used to find if a string exists in a table
local function has_string(array, string)
    for i = 1, #array do
        if array[i] == string then return true end
    end
    return false
end

--MAKE PASS THROUGH NAME LIST-- make a list of all node names which gas can pass through
local pass_names = {}
for i = 1, #pass_through do
    local entry = pass_through[i]
    if string.find(entry,"group:") then --check if entry is a group name 
        local group_name = string.split(entry, "group:") 
        for name, def in pairs(minetest.registered_nodes) do 
            if def.groups[group_name[1]] then --Add all members of a group to the list
                pass_names[#pass_names + 1] = name
            end
        end
    else
        pass_names[#pass_names + 1] = entry
    end
end

--MAKE IGNITER NAME LIST-- make a list of all node names which ignite gas
local igniter_names = {}
for i = 1, #gas_igniter do
    local entry = gas_igniter[i]
    if string.find(entry,"group:") then --Add all members of a group to the list
        local group_name = string.split(entry, "group:") --check if entry is a group name
        for name, def in pairs(minetest.registered_nodes) do
            if def.groups[group_name[1]] then
                igniter_names[#igniter_names + 1] = name
            end
        end
    else
        igniter_names[#igniter_names + 1] = entry
        local split_name = string.split(entry,":")
        local mod_name = split_name[1]
        local blk_name = split_name[2]
        for name, def in pairs(minetest.registered_nodes) do
            if string.find(name, "moreblocks:") and string.find(name, blk_name) then
                if not has_string(igniter_names, name) then
                    igniter_names[#igniter_names + 1] = name
                end
            end
        end
    end
end
        
----------------------------------------------------------------------------
--                            FUNCTIONS
----------------------------------------------------------------------------

--KILL GAS BOOL-- Returns boolean, true if gas meets kill criteria
local function kill_gas_bool(pos)
    --GOAL: Gas near generator does not die. Away from generator, gas which is touching something solid
    --      will survive. If it is not touching something solid and is touching "air", gas will die.
    local sup_pos = minetest.find_node_near(pos, thrive_radius, gas_support)
    if sup_pos then
        return false
    else
        local air_count = 0
        for i = 1, #neighbors do --uses extended neighbor def
            local chk_pos = vector.add(pos, neighbors[i])
            local chk_node = minetest.get_node(chk_pos) 
            if chk_node.name ~= "air" and chk_node.name ~= lp_gas and not has_string(pass_names,chk_node.name) then
                return false 
            elseif chk_node.name == "air" or has_string(pass_names,chk_node.name) then 
                air_count = air_count + 1
            end
        end
        if air_count > 0 then
            return true
        end
    end
end

--PLACE GAS-- Moves gas once new location of gas node has been determined
local function place_gas(target_pos, target_name, placing_pos, placing_name)
    local new_param2 --Param2 holds the index in neighbors to which gas should not move back to.
    local dir = vector.direction(target_pos,placing_pos)
    for key, pos in ipairs(neighbors) do
        if vector.equals(dir,pos) then
            new_param2 = key
        end
    end
    
    if target_name == lp_gas then
        minetest.set_node(target_pos,{name = hp_gas, param2 = new_param2})
    else
        minetest.set_node(target_pos,{name = lp_gas, param2 = new_param2})
    end

    if placing_name == hp_gas then
        minetest.set_node(placing_pos,{name = lp_gas})
    else
        minetest.set_node(placing_pos,{name = "air"})
    end
end

--GAS ON TIMER--
local function gas_on_timer(pos)
    local node = minetest.get_node(pos)

    --Does gas meet kill conditions?
    if kill_gas_bool(pos) then
        minetest.remove_node(pos)
        return
    end

    --Build list of replaceable neighbors
    local open_nei = {}
    local nei_count = 0
    for i = 1, #neighbors - 8 do --only first 6 neightbors
        local chk_pos = vector.add(pos, neighbors[i])
        local chk_node = minetest.get_node(chk_pos)
        if node.param2 ~= i and (chk_node.name == "air" or chk_node.name == lp_gas) then --Exclude past position
            open_nei[i] = {nei_name = chk_node.name, nei_pos = chk_pos}
            nei_count = nei_count+1
        end
    end

    --Turn off node timer if no movement options. Node awakened by ABM
    if 0 >= nei_count then
        return false
    end

    --Move up
    local above_name 
    local above_pos
    if open_nei[6] then
        above_name = open_nei[6].nei_name
        above_pos  = open_nei[6].nei_pos
        if above_name == "air" then
            --print(node.name..": GAS MOVES UP")
            place_gas(above_pos, above_name, pos, node.name)
            return true
        end
    end
    
    --Move to random side
    local air_sides = {} --Contains index keys from open_nei paired with side "air" nodes
    local gas_sides = {} --Contains index keys from open_nei paired with side LP gas nodes
    for i = 1, 4 do --Finds open_nei indeses which correspond to node sides.
        if open_nei[i] and open_nei[i].nei_name == "air" then
            air_sides[#air_sides + 1] = i
        elseif open_nei[i] and open_nei[i].nei_name == lp_gas then
            gas_sides[#gas_sides + 1] = i
        end
    end
    if #air_sides > 0 then --If a side position is available...
        local index = air_sides[math.random(1,#air_sides)] --...randomly pick available side
        --print(node.name..": GAS MOVES TO RAND SIDE")
        place_gas(open_nei[index].nei_pos, open_nei[index].nei_name, pos, node.name)
        return true
    end

    --Compress up
    if above_name and above_name == lp_gas then
        --print(node.name..": GAS COMPRESSES UP")
        place_gas(above_pos, above_name, pos, node.name)
        return true
    end

    --HP specific movement
    if node.name == hp_gas then
        --HP will compress to Side
        if #gas_sides > 0 then --If a side position is available...
            local index = gas_sides[math.random(1,#gas_sides)] --...randomly pick available side
            place_gas(open_nei[index].nei_pos, open_nei[index].nei_name, pos, node.name)
            --print(node.name..": GAS COMPRESSES TO SIDE")
            return true
        end
    end

    --Gas can drop down into air, using nei_count ensures that there is not LP gas around
    if nei_count == 1 and open_nei[5] and open_nei[5].nei_name == "air" then 
        place_gas(open_nei[5].nei_pos, open_nei[5].nei_name, pos, node.name)
        --print(node.name..": MOVES DOWN")
        return true
    end
    
    return true
end

--GENERATOR ON TIMER-- function governing output of gas
local function generator_on_timer(pos)
    for i = 1, #neighbors - 8 do --only first 6 neightbors
        local chk_pos  = vector.add(pos,neighbors[i])
        local chk_node = minetest.get_node(chk_pos)
        if has_string(pass_names,chk_node.name) then --if pass through node, set gas further out
            local far_nei = vector.multiply(neighbors[i],2)
            chk_pos  = vector.add(pos,far_nei)
            chk_node = minetest.get_node(chk_pos)
        end

        if chk_node.name == "air" then
            minetest.set_node(chk_pos,{name = lp_gas})
        elseif chk_node.name ==lp_gas then
            minetest.set_node(chk_pos,{name = hp_gas})
        end
    end
    return true
end

--EXPLOSION EFECTS--
local function explosion_effects(pos)
    minetest.add_particlespawner({
        amount = 70,
        time = 1,
        minpos = (pos),
        maxpos = {x=pos.x, y=pos.y+5, z=pos.z},
        minvel = {x=-3, y=-2, z=-3},
        maxvel = {x=3,  y=20,  z=3},
        minacc = vector.new(),
        maxacc = vector.new(),
        minexptime = 0.5,
        maxexptime = 1,
        minsize = 8,
        maxsize = 16,
        texture = "oil_separation_smoke.png",
    })
    minetest.sound_play("oil_separation_fire_flash", {pos = pos, gain = 1.5, max_hear_distance = 36})
end

--EXPLOSION-- 
--Consider using function explode(pos, radius) found in PlizAdam's TNT mod. Using VoxelManip is necessary for large radius explosions
local function explosion(pos)
    explosion_effects(pos)
    for i = 1, #fireball do
        local chk_pos = vector.add(pos, fireball[i])
        if minetest.is_protected(chk_pos, "") then
            return
        end
        local chk_name = minetest.get_node(chk_pos).name
        if minetest.get_item_group(chk_name,"flammable") > 0 or minetest.get_item_group(chk_name,"methane") > 0 then
            minetest.set_node(chk_pos,{name = "fire:basic_flame"})
        else
            minetest.remove_node(chk_pos)
        end
    end
end

----------------------------------------------------------------------------
--                            NODE REGISTRATION
----------------------------------------------------------------------------
--NOTE: Gases should not be in group flammable, this would allow fire to spread downwards.
--LOW PRESURE GAS-- 
minetest.register_node(lp_gas, {
    description = "Low Presure Methane Gas",
    drawtype = "airlike",
    paramtype = "light",
    sunlight_propagates = true,
    --PARAM2 is used to restrict gas movement
    drop = '',
    walkable = false,
    pointable = false,
    buildable_to = true,
    --drowning = 3,
    groups = {methane = 1, not_in_creative_inventory = 1},
	floodable = true,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(gas_spread_min,gas_spread_max))
	end,
	on_timer = gas_on_timer,
})

--HIGH PRESURE GAS-- 
minetest.register_node(hp_gas, {
    description = "High Presure Methane Gas",
    drawtype = "glasslike",
    paramtype = "light",
    sunlight_propagates = true,
    --PARAM2 is used to restrict gas movement
    tiles = {"oil_separation_methane_gas_hp.png"},
    --[[
    tiles = {
		{
			name = "oil_separation_methane_gas_hp_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 5.0,
			},
		},
    },
    --]]
    use_texture_alpha = true,
    drop = '',
    walkable = false,
    pointable = false,
    buildable_to = true,
    drowning = 3,
    groups = {methane = 1, not_in_creative_inventory = 1},
    post_effect_color = {r=255, g=255, b=255, a = 40},
	floodable = true,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(gas_spread_min,gas_spread_max))
	end,
	on_timer = gas_on_timer,
})

--SEED PASTE GASLESS--
minetest.register_node("oil_separation:seed_paste_gasless", {
    description = "Gasless Seed Paste",
    tiles = {"oil_separation_seed_paste_dry.png"},
    groups = {crumbly = 3, falling_node = 1, inert = 1, not_in_creative_inventory = 1, flammable = 1},
    sounds = default.node_sound_sand_defaults(),
})
----------------------------------------------------------------------------
--                            NODE OVERRIDES
----------------------------------------------------------------------------
--SEED PASTE DRY--
minetest.override_item ("oil_separation:seed_paste_dry", {
    drop = "oil_separation:seed_paste_gasless",
    on_construct = function(pos)
        minetest.get_node_timer(pos):set(gas_to_gasless, 0)
    end,
    on_timer = function(pos)
        minetest.set_node(pos,{name = "oil_separation:seed_paste_gasless"})
    end,
})

----------------------------------------------------------------------------
--                             ABM's
----------------------------------------------------------------------------

--NODE:METHANE GAS-- Causes fire to spread through gas.
minetest.register_abm({
    label = "Cause Fire to Burn Gas",
    nodenames = {"group:methane"},
    neighbors = {"air","fire:basic_flame","group:lava","group:torch","walking_light:light",lp_gas},
    interval = 3,
    chance = 1,
    catch_up = false,
    action = function(pos, node, active_object_count, active_object_count_wider)

        --Gas should be on fire
        if minetest.find_node_near(vector.add(pos,{x=0,y=-1,z=0}),1, igniter_names) then
            --HP gas should Explode
            if node.name == hp_gas then
                --local above_pos = {x=pos.x, y=pos.y+1, z=pos.z}
                --local above_node = minetest.get_node(above_pos)
                --if above_node.name == node.name then
                if minetest.find_node_near(pos, 1, "oil_separation:methane_gas_hp") then
                    explosion(pos)
                    return
                end
            end
            minetest.set_node(pos, {name = "fire:basic_flame"})
            return
        end

        --Awaken timed-out gas
        if 0 >= minetest.get_node_timer(pos):get_timeout() then
            for i = 1, #neighbors - 8 do
                local chk_pos = vector.add(pos,neighbors[i])
                local chk_node = minetest.get_node(chk_pos)
                if chk_node.name == "air" or chk_node.name == lp_gas then
                    minetest.set_node(pos,{name = node.name}) --Re-sets node and sets param2 to 0
                    minetest.get_node_timer(pos):start(gas_spread_max)
                    print(node.name..": GAS AWAKENS")
                    return
                end
            end
        end
    end,
})

--MULTI NODE-- Causes gas to pass through various nodes
minetest.register_abm({
    label = "Gas Pass Through",
    nodenames = pass_names,
    neighbors = {"group:methane"},
    interval = gas_spread_min,
    chance = 1,
    catch_up = false,
    action = function(pos)
        local entering_pos
        local entering_node
        for i = 1, #neighbors - 9 do --no need to check above
            local chk_pos = vector.add(pos,neighbors[i])
            local chk_node = minetest.get_node(chk_pos)
            if minetest.get_item_group(chk_node.name,"methane") > 0 then
                entering_pos = chk_pos
                entering_node = minetest.get_node(chk_pos)
                break
            end
        end

        if entering_pos then
            local exiting_dir  = vector.direction(entering_pos,pos) --reversed order to get oposite direction
            local exiting_pos  = vector.add(pos,exiting_dir)
            local exiting_name = minetest.get_node(exiting_pos).name
            if exiting_name == "air" or exiting_name == lp_gas then
                place_gas(exiting_pos, exiting_name, entering_pos, entering_node.name)
                return
            end
        end
    end,
})

--MULTI NODE-- places gas around gas generators
minetest.register_abm({
    label = "Adds Gas node To Waste",
    nodenames = gas_gen,
    interval = gas_gen_int,
    chance = gas_gen_chance,
    catch_up = false,
    action = function(pos, node, active_object_count, active_object_count_wider)
        for i = 1, #neighbors - 8 do 
            local chk_pos = vector.add(pos, neighbors[i]) 
            local chk_node = minetest.get_node(chk_pos) 
            if chk_node.name == "air" then 
                minetest.set_node(chk_pos, {name = lp_gas})
            elseif chk_node.name == lp_gas then
                minetest.set_node(chk_pos, {name = hp_gas})
            end
        end
    end,
})