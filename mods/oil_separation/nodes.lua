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
--IS HEATED-- Detects if node is heated
oil_separation.is_heated = function(pos, depth)
    local max_pos = {x=pos.x+2, y=pos.y,       z=pos.z+2}
    local min_pos = {x=pos.x-2, y=pos.y-depth, z=pos.z-2}
    local near_heat = minetest.find_nodes_in_area(max_pos, min_pos, {"fire:basic_flame", "default:lava_source"})
    if #near_heat >= 1 then
        return true
    else
        return false
    end
end

--COOL LAVA-- Cools Lava to stone in area
oil_separation.cool_lava = function(pos, depth)
    local loss_chance = 1/oil_separation.energy_loss_chance
    if math.random() <= loss_chance then
        local max_pos = {x=pos.x+2, y=pos.y,       z=pos.z+2}
        local min_pos = {x=pos.x-2, y=pos.y-depth, z=pos.z-2}
        local lava_pos = minetest.find_nodes_in_area(max_pos, min_pos, {"default:lava_source"})
        if lava_pos then
            local dest_pos = lava_pos[math.random(1, #lava_pos)]
            minetest.set_node(dest_pos, {name = "default:stone"})
            minetest.sound_play("default_cool_lava", {pos = pos, max_hear_distance = 16, gain = 0.25})
        end
    end
end

--OILY PASTE ON TIMER-- Controls oil separation when touching watersource (Strainer separation is controled by "strainer_settings")
local function seed_paste_oily_on_timer(pos) --This functionality is on a timer, not incuded in the ABM because of time delay needed
    local node = minetest.get_node(pos)
    local above_pos  = {x=pos.x, y=pos.y+1, z=pos.z}
    local above_node = minetest.get_node(above_pos)
    local under_node = minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z})
    if under_node.name == "strainer:strainer_cloth_active" then --If strainer, water does not separate.
        return true
    elseif (above_node.name == "default:water_source" or above_node.name == "default:river_water_source" or above_node.name == "oil_separation:seed_oil_source") and
           oil_separation.is_heated(pos,2) then --Separates in water if heated (oil will be replaced if there is not water above the oily node)
        local chance = (1/oil_separation.fire_chance)+0.05
        minetest.set_node(above_pos,{name = "oil_separation:seed_oil_source"})
        oil_separation.cool_lava(pos,2) --has chance of making lava cool to stone
        if math.random() > chance then
            minetest.set_node(pos,{name = "oil_separation:seed_paste_dry"})
            return false
        end
    end
    return true
end

--NODE SOUND SPLAT-- Sounds for oily paste  
oil_separation.node_sound_splat = function(table)
	table = table or {}
	table.footstep = table.footstep or
            {name = "oil_separation_splat_step", gain = 0.4}
    table.dig = table.dig or
			{name = "oil_separation_splat_dig", gain = 1}
	table.dug = table.dug or
			{name = "oil_separation_splat_dug", gain = 1}
	table.place = table.place or
			{name = "oil_separation_splat_place", gain = 1}
	default.node_sound_defaults(table)
	return table
end

--NODE SOUND STICKY-- Sounds for oil block
oil_separation.node_sound_sticky = function(table)
	table = table or {}
	table.footstep = table.footstep or
            {name = "oil_separation_sticky_step", gain = 0.4}
    table.dig = table.dig or
			{name = "oil_separation_sticky_dig", gain = 1}
	table.dug = table.dug or
			{name = "oil_separation_sticky_dug", gain = 1}
	table.place = table.place or
			{name = "oil_separation_sticky_place", gain = 1}
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
            oil_block = id_name.."_block",
        },
        strainer_settings = { --used by "strainer mod"
            output = def.strainer_settings.output or id_name.."_source",
            residual = def.strainer_settings.residual or "air",
            alt_residual = def.strainer_settings.alt_residual or nil,
            do_alt_residual_bool = def.strainer_settings.do_alt_residual_bool or nil,
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

--CREATING OIL BLOCK-- Function used when registering an oil to create oil block
local function create_oil_block(id_name, def)
    minetest.register_node(id_name.."_block", {
        description = def.description.." Block",
        tiles = def.oil_block_settings.texture,
        groups = {crumbly = 3, flammable = 1, oil_block = 1},
        sounds = oil_separation.node_sound_sticky(),
        oil_separation_settings = {
            oil_source = id_name.."_source",
        },
    })

    minetest.register_craft({
	    type = "fuel",
	    recipe = id_name.."_block",
	    burntime = 100,
    })
end

--OIL REGISTRATION-- Function used to register an oil and its related nodes
oil_separation.register_oil = function(id_name,def)
    -- Create oil-related nodes
    create_oil_source(id_name,def)
    create_oil_flowing(id_name,def)
    create_oil_block(id_name,def)
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
    groups = {crumbly = 3, falling_node = 1, strainable = 1, flammable = 1},
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
        alt_residual = "oil_separation:seed_paste_oily",
        do_alt_residual_bool = function(pos)
            local chance = 1/oil_separation.fire_chance --Chance that oil will produce again if near fire
            if math.random() <= chance and oil_separation.is_heated(pos,2) then
                oil_separation.cool_lava(pos,2)
                return true --Do alternate
            else
                return false --Do not do alternate
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

--FUEL: SEED PASTE OILY--
minetest.register_craft({
	type = "fuel",
	recipe = "oil_separation:seed_paste_oily",
	burntime = 50,
})

--SEED PASTE DRY--
minetest.register_node("oil_separation:seed_paste_dry", {
    description = "Dry Seed Paste",
    tiles = {"oil_separation_seed_paste_dry.png"},
    groups = {crumbly = 3, falling_node = 1, not_in_creative_inventory = 1, flammable = 1, waste = 1},
    sounds = default.node_sound_sand_defaults(),
    crop_blight_settings = {
        infectable_settings = {
            chance = 1,
            infected_version = "oil_separation:seed_paste_dry_blighted",
        }
    }
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
				length = 4,
			},
		},
		{
			name = "oil_separation_seed_oil_flowing_animated.png", --TODO do I need this?
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 4,
			},
		},
    },
    alpha = 160,
    liquid_viscosity = 14,
    liquid_range = 2,
    bucket = "oil_separation_seed_oil_bucket.png",
	post_effect_color = {a = 50, r = 193, g = 200, b = 0},
	source_groups = {liquid = 3, flammable = 3, oil=1, not_in_creative_inventory = 1},
    flowing_groups = {liquid = 3, not_in_creative_inventory = 1, oil_flowing = 1},
    strainer_settings = {
        strain_time = 10,
        drip_color = "yellow",
    },
    oil_block_settings= {
        texture = {name = "oil_separation_seed_oil_block.png"},
    },
})