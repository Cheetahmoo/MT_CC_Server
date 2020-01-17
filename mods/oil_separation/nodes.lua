----------------------------------------------------------------------------
--                       OIL SEPARATION: NODES
----------------------------------------------------------------------------
local neighbors = { --Neighbor definition
    {x= 1,y= 0,z= 0}, --East   (1)
    {x=-1,y= 0,z= 0}, --West   (2)
    {x= 0,y= 0,z= 1}, --North  (3)
    {x= 0,y= 0,z=-1}, --South  (4)
    {x= 0,y=-1,z= 0}, --Under  (5)
    {x= 0,y= 1,z= 0}, --Above  (6)
}


----------------------------------------------------------------------------
--                          NODE FUNCIONALITY
----------------------------------------------------------------------------
--IS FIRE HEATING-- Detects if fire is near but not touching
local function is_fire_heating(pos)
    if not minetest.find_node_near(pos, 1, "fire:basic_flame") then --If node is not on fire
        for i=1, 5 do --don't check up
            local far_nei = vector.multiply(neighbors[i], 2)
            local chk_pos = vector.add(pos, far_nei)
            local chk_node = minetest.get_node(chk_pos)
            if chk_node.name == "fire:basic_flame" then
                return true
            end
        end
    end
    return false
end

--OILY PASTE ON TIMER-- Controls oil separation when touching watersource (Strainer separation is controled by "strainer_settings")
local function seed_paste_oily_on_timer(pos) --This functionality is on a timer, not incuded in the ABM because of time delay needed
    local node = minetest.get_node(pos)
    local above_pos  = {x=pos.x, y=pos.y+1, z=pos.z}
    local above_node = minetest.get_node(above_pos)
    local under_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
    if under_node.name == "strainer:strainer_cloth_active" then --If strainer, water does not separate.
        return true
    elseif (above_node.name == "default:water_source" or above_node.name == "default:river_water_source") and is_fire_heating(pos) then --Separates in water if heated
        local chance = 1/oil_separation.fire_chance
        minetest.set_node(above_pos,{name = "oil_separation:seed_oil_source"})
        if math.random() <= chance then
            minetest.set_node(pos,{name = "oil_separation:seed_paste_dry"})
            return false
        end
    end
    return true
end

--NODE SOUND SPLAT-- Sounds for paste and waste  
oil_separation.node_sound_splat = function(table)
	table = table or {}
	table.footstep = table.footstep or
            {name = "oil_separation_step", gain = 0.4}
    table.dig = table.dig or
			{name = "oil_separation_dig_paste", gain = 1}
	table.dug = table.dug or
			{name = "oil_separation_dug_paste", gain = 1}
	table.place = table.place or
			{name = "oil_separation_place_paste", gain = 1}
	default.node_sound_defaults(table)
	return table
end


----------------------------------------------------------------------------
--                          REGISTRATION FUNCTIONS
----------------------------------------------------------------------------
--CREATING OIL SOURCE-- Function used when registering an oil to create the oil source
local function create_oil_source(id_name, def)
    def.source_groups["oil"] = 1 --Required group membership
    def.source_groups["strainable"] = 1
    minetest.register_node(id_name.."_source", {
        description = def.description .. " Source",
        drawtype = "liquid",
        tiles = def.texures_source_animated,
        special_tiles = def.special_tiles_source,
        alpha = def.alpha,
        paramtype = "light",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        is_ground_content = false,
        drop = "",
        drowning = 1,
        liquidtype = "source",
        liquid_alternative_flowing = id_name.."_flowing",
        liquid_alternative_source = id_name.."_source",
        liquid_viscosity = def.liquid_viscosity,
        liquid_range = def.liquid_range,
        liquid_renewable = false,
        post_effect_color = def.post_effect_color,
        groups = def.source_groups,
        on_construct = def.on_construct or nil,
        on_timer = def.on_timer or nil,
        oil_separation_settings = {
            oil_source = id_name.."_source",
        },
        strainer_settings = { --used by "strainer mod"
            output = def.strainer_settings.output or id_name.."_source",
            residual = def.strainer_settings.residual or "air",
            alt_residual = def.strainer_settings.alternate_residual or nil,
            do_alt_residual_bool = def.strainer_settings.alternate_residual or nil,
            strain_time = def.strainer_settings.strain_time or "yellow",
            drip_color = def.strainer_settings.drip_color or 10,
        },
    })
end

--CREATING OIL FLOWING-- Function used when registering an oil to create flowing oil
local function create_oil_flowing(id_name, def)
    def.flowing_groups["oil_flowing"] = 1 --Required group membership
    minetest.register_node(id_name.."_flowing", {
        description = "Flowing "..def.description,
        drawtype = "flowingliquid",
        tiles = def.texures_source,
        special_tiles = def.special_tiles_flowing_animated,
        alpha = def.alpha,
        paramtype = "light",
        paramtype2 = "flowingliquid",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        liquid_renewable = false,
        is_ground_content = false,
        drop = "",
        drowning = 1,
        liquid_range = def.liquid_range,
        liquidtype = "flowing",
        liquid_alternative_flowing = id_name.."_flowing",
        liquid_alternative_source = id_name.."_source",
        liquid_viscosity = 10,
        post_effect_color = def.post_effect_color,
        groups = def.flowing_groups
    })
end

--OIL REGISTRATION-- Function used to register an oil and its related nodes
oil_separation.register_oil = function(id_name,def)
    -- Create oil-related nodes
    create_oil_source(id_name,def)
    create_oil_flowing(id_name,def)
    --create_oil_bottle(id_name,def.bottled)
    bucket.register_liquid(
        id_name.."_source",        --source name
        id_name.."_flowing",       --flowing name
        id_name.."_bucket",        --item name
        def.bucket,                --inventory image
        def.description.." Bucket" --description
    )
    minetest.register_craft({
        type = "fuel",
        recipe = id_name.."_bucket",
        burntime = 100,
        replacements = {{id_name.."_bucket", "bucket:bucket_empty"}},
    })
end


----------------------------------------------------------------------------
--                          NODE REGISTRATION
----------------------------------------------------------------------------
--SEED PASTE OILY--
minetest.register_node("oil_separation:seed_paste_oily", {
    description = "Oily Seed Paste",
    tiles = {
		{
			name = "oil_separation_seed_paste_oily_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4.0,
			},
		},
	},
    groups = {crumbly = 3, falling_node = 1, inert = 1, strainable = 1, flammable = 1},
    sounds = oil_separation.node_sound_splat(),
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(oil_separation.separation_time)
    end,
    on_timer = seed_paste_oily_on_timer,
    strainer_settings = {
        output = "oil_separation:seed_oil_source",
        residual = "oil_separation:seed_paste_dry",
        strain_time = oil_separation.separation_time,
        drip_color = "yellow",
        alternate_residual = "oil_separation:seed_paste_oily",
        alternate_bool = function(pos)
            local chance = 1/oil_separation.fire_chance --Chance that oil will produce again if near fire
            if math.random() > chance and is_fire_heating(pos) then
                return true
            else
                return false
            end
        end,
    },
})

--CRAFT: SEED PASTE OILY--
minetest.register_craft({
    type = "shaped",
    recipe = {--Designed to use up extra seeds
        {"group:seed", "group:seed", "group:seed"},
        {"group:seed", "group:seed", "group:seed"},
        {"group:seed", "group:seed", "group:seed"},
    },
    output = "oil_separation:seed_paste_oily",
})

--SEED PASTE DRY--
minetest.register_node("oil_separation:seed_paste_dry", {
    description = "Dry Seed Paste",
    tiles = {"oil_separation_seed_paste_dry.png"},
    groups = {crumbly = 3, falling_node = 1, not_in_creative_inventory = 1, flammable = 1, waste = 1},
    sounds = default.node_sound_sand_defaults(),
})

--FUEL: SEED PASTE DRY--
minetest.register_craft({
	type = "fuel",
	recipe = "oil_separation:seed_paste_dry",
	burntime = 2,
})

--SEED OIL--
oil_separation.register_oil("oil_separation:seed_oil",{
    description = "Seed Oil",
    texures_source_animated = {
		{
			name = "oil_separation_seed_oil_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
    special_tiles_source = {
		{
			name = "oil_separation_seed_oil_source_animated.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
			backface_culling = false,
		},
	},
    special_tiles_flowing_animated = {
		{
			name = "oil_separation_seed_oil_flowing_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
		{
			name = "oil_separation_seed_oil_flowing_animated.png", --TODO do I need this?
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 0.8,
			},
		},
	},
    alpha = 160,
    liquid_viscosity = 14,
    liquid_range = 2,
    bucket = "oil_separation_seed_oil_bucket.png",
	post_effect_color = {a = 50, r = 193, g = 200, b = 0},
	source_groups = {floats_on_water = 1, liquid = 3, flammable = 3, oil=1, not_in_creative_inventory = 1},
    flowing_groups = {floats_on_water = 1, liquid = 3, not_in_creative_inventory = 1, oil_flowing = 1},
    strainer_settings = {
        strain_time = 10,
        drip_color = "yellow",
    }
})