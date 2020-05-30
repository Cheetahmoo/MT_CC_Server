----------------------------------------------------------------------------
--                               SETTINGS
----------------------------------------------------------------------------
oil_stains = {} --Establish "oil_stains" name space

--"stain_time" controls how long a stain must sit on top of a material 
--before soaking in and changing its color.
local stain_time_max = 10
local stain_time_min = 5


----------------------------------------------------------------------------
--                            FUNCTIONS
----------------------------------------------------------------------------
--REGISTER STAINABLE NODE-- Build directory indicating how stain effects a stainable node
local staining_directory = {}
oil_stains.register_stainable_node = function(name, def)
    if minetest.registered_nodes[name] then
        minetest.registered_nodes[name].groups["catches_oil"] = 1
    end
    staining_directory[name] = {}
    for dye, node in pairs(def) do
        staining_directory[name]["oil_stains:stain_"..dye.."_source"] = node
    end
end

--DYE ON USE-- Punch oil with dye turns oil into stain
local dye_to_stain_settings = { -- which dye is used to create which stain colors
    ["dye:white"]      = "white",
    ["dye:grey"]       = "black",
    ["dye:dark_grey"]  = "black",
    ["dye:black"]      = "black",
    ["dye:red"]        = "red",
    ["dye:yellow"]     = "yellow",
    ["dye:green"]      = "yellow",
    ["dye:cyan"]       = "blue",
    ["dye:blue"]       = "blue",
    ["dye:magenta"]    = "red",
    ["dye:orange"]     = "yellow",
    ["dye:violet"]     = "blue",
    ["dye:brown"]      = "black",
    ["dye:pink"]       = "red",
    ["dye:dark_green"] = "blue",
}
--[[ OLD DELETE IF NO BUGS FOUND IN "register on punch" below 
local function dye_on_use(itemstack, user, pointed_thing)
    --Pointed_thing checks 
    if not pointed_thing or pointed_thing.type ~= "node" then
		return
    end

    local node = minetest.get_node(pointed_thing.under)
	if node.name ~= "oil_separation:seed_oil_source" then
		return
    end

    --Protection check TODO: check protection
    if minetest.is_protected(pointed_thing.under, user:get_player_name()) then
		minetest.record_protection_violation(pointed_thing.under, user:get_player_name())
		return
    end

    --Change oil to stain
    local wielded_dye = itemstack:get_name()
    local stain_name  = "oil_stains:stain_"..dye_to_stain_settings[wielded_dye].."_source"
    if minetest.registered_nodes[stain_name] then
        minetest.set_node(pointed_thing.under,{name = stain_name})
        itemstack:take_item()
        return itemstack
    end
end
--]]

--USE DYE TO STAIN THE OIL
minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
    if not (minetest.get_item_group(puncher:get_wielded_item():get_name(),"dye") >= 1) then
        return
    end

    if not pointed_thing or pointed_thing.type ~= "node" then
		return
    end

    local node = minetest.get_node(pointed_thing.under)
	if not (node.name == "oil_separation:seed_oil_source") then
		return
    end

    --Protection check TODO: check protection
    if minetest.is_protected(pointed_thing.under, puncher:get_player_name()) then
		minetest.record_protection_violation(pointed_thing.under, puncher:get_player_name())
		return
    end

    --Change oil to stain
    local itemstack = puncher:get_wielded_item()
    local wielded_dye = itemstack:get_name()
    local stain_name  = "oil_stains:stain_"..dye_to_stain_settings[wielded_dye].."_source"
    if minetest.registered_nodes[stain_name] then
        minetest.set_node(pointed_thing.under,{name = stain_name})
        itemstack:take_item()
        puncher:set_wielded_item(itemstack)
        return itemstack
    end
end)

--STAIN ON TIMER-- stain soaks into lower material
local function stain_on_timer(pos, elapsed)
    local under_pos = {x=pos.x, y=pos.y-1, z=pos.z}
    if minetest.is_protected(under_pos, "") then
        return
    end

    local node = minetest.get_node(pos)
    local under_node = minetest.get_node(under_pos)
    if staining_directory[under_node.name] then
        local change_to = staining_directory[under_node.name][node.name] --directory[material][color of stain] = new colored node
        if not change_to or not minetest.registered_nodes[change_to] then
            minetest.log("error", "From mod Oil_Stains: A stained version of "..under_node.name.." is not a registered node or is a nill value.")
            return
        end
        minetest.set_node(under_pos, {name = change_to})
        minetest.remove_node(pos)
    end
    minetest.get_node_timer(pos):set(math.random(stain_time_min, stain_time_max),0)
end


----------------------------------------------------------------------------
--                        STAIN REGISTRATION
----------------------------------------------------------------------------

--Properties for each stain
local stains = {
    { --RED
    name = "oil_stains:stain_red", desc = "Red Stain", added_dye = "red", animatedS = "oil_stains_stain_red_source_animated.png", 
    animatedF = "oil_stains_stain_red_flowing_animated.png", bucket = "oil_stains_stain_red_bucket.png", block = "oil_stains_stain_red_block.png",
    post_effect_color = {a = 100, r = 200, g = 0, b = 0}
    },
    
    { --BLUE
    name = "oil_stains:stain_blue", desc = "Blue Stain", added_dye = "blue", animatedS = "oil_stains_stain_blue_source_animated.png",
    animatedF = "oil_stains_stain_blue_flowing_animated.png", bucket = "oil_stains_stain_blue_bucket.png", block = "oil_stains_stain_blue_block.png",
    post_effect_color = {a = 100, r = 0, g = 0, b = 200}
    },
    
    { --YELLOW
    name = "oil_stains:stain_yellow", desc = "Yellow Stain", added_dye = "yellow", animatedS = "oil_stains_stain_yellow_source_animated.png",
    animatedF = "oil_stains_stain_yellow_flowing_animated.png", bucket = "oil_stains_stain_yellow_bucket.png", block = "oil_stains_stain_yellow_block.png",
    post_effect_color = {a = 100, r = 150, g = 200, b = 0}
    },
    
    { --BLACK
    name = "oil_stains:stain_black", desc = "Black Stain", added_dye = "black", animatedS = "oil_stains_stain_black_source_animated.png",
    animatedF = "oil_stains_stain_black_flowing_animated.png", bucket = "oil_stains_stain_black_bucket.png", block = "oil_stains_stain_black_block.png",
    post_effect_color = {a = 100, r = 0, g = 0, b = 0}
    },

    { --white
    name = "oil_stains:stain_white", desc = "White Stain", added_dye = "white", animatedS = "oil_stains_stain_white_source_animated.png",
    animatedF = "oil_stains_stain_white_flowing_animated.png", bucket = "oil_stains_stain_white_bucket.png", block = "oil_stains_stain_white_block.png",
    post_effect_color = {a = 100, r = 0, g = 0, b = 0}
    },
}

--Register Stains as a type of oil
for i=1, #stains do
    --Register stains as oils
    oil_separation.register_oil(stains[i].name,{
        description = stains[i].desc,
        texures_source_animated = {
            {
                name = stains[i].animatedS,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 2.0,
                },
            },
        },
        special_tiles_source = {
            -- New-style water source material (mostly unused)
            {
                name = stains[i].animatedS,
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
                name = stains[i].animatedF,
                backface_culling = true,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 4,
                },
            },
            {
                name = stains[i].animatedF,
                backface_culling = true,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 4,
                },
            },
        },
        alpha = 200,
        liquid_viscosity = 14,
        liquid_range = 2,
        bucket = stains[i].bucket,
        post_effect_color = stains[i].post_effect_color,
        source_groups = {floats_on_water = 1, liquid = 3, flammable = 3, oil = 1, stains = 1, not_in_creative_inventory = 1},
        flowing_groups = {floats_on_water = 1, liquid = 3, not_in_creative_inventory = 1, oil_flowing=1},
        on_construct = function(pos)
            minetest.get_node_timer(pos):set(math.random(stain_time_min, stain_time_max),0)
        end,
        on_timer = stain_on_timer,
        strainer_settings = {
            output = "oil_separation:seed_oil_source",
            residual = "dye:"..stains[i].added_dye,
            strain_time = 10,
            drip_color = "yellow",
        },
        oil_block_settings = {
            texture = {name = stains[i].block},
        },
    })
end

--Stain Crafting
for dye, color in pairs(dye_to_stain_settings) do
    --override dye to allow for dye_on_use
    minetest.override_item(dye,{
        liquids_pointable = true,
        on_use = dye_on_use,
    })

    --Register stain craft
    minetest.register_craft({
	    type = "shapeless",
	    output = "oil_stains:stain_"..color.."_bucket", 
	    recipe = {"oil_separation:seed_oil_bucket", dye},
    })
end


----------------------------------------------------------------------------
--                      RUN REGISTRATION SCRIPT
----------------------------------------------------------------------------
oil_stains.path = minetest.get_modpath("oil_stains")

dofile(oil_stains.path .. "/register_stainable.lua")