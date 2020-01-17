-----------------------------------------------------------------------------
--                              SETTINGS
----------------------------------------------------------------------------
local porcelain_colors = { --name, dye used in craft
	{"red", "red"},
    {"brown", "brown"},
    {"orange", "orange"},
    {"yellow", "yellow"},
    {"avocado", "green"},
    {"green", "dark_green"},
    {"cyan", "cyan"},
    {"blue", "blue"},
    {"violet", "violet"},
    {"black", "black"},
    {"white", "white"},
}


----------------------------------------------------------------------------
--                      PORCELAIN REGISTRATION
----------------------------------------------------------------------------
for i, row in ipairs(porcelain_colors) do
    local color = row[1]
    local desc = string.gsub(color, "_", " "):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
    local dye = row[2]
    
    --Stained Clay
	minetest.register_node("porcelain:stained_clay_"..color,{
		description = desc.." Stained Clay",
		tiles = {"default_clay.png^porcelain_stained_clay_"..color..".png"},
		groups = {crumbly = 3},
		sounds = default.node_sound_dirt_defaults(),
    })

    minetest.register_craft({
		type = "shapeless",
		output = "porcelain:stained_clay_"..color,
		recipe = {"dye:"..dye, "default:clay"},
    })

    --Porcelain
    local porcelain_def = {
        name = "porcelain:porcelain_"..color,
        description = desc.." Porcelain",
        tiles = {"porcelain_base.png^porcelain_porcelain_"..color..".png"},
        sounds = default.node_sound_stone_defaults(),
    }

    minetest.register_node(porcelain_def.name, {
        description = porcelain_def.description,
        tiles = porcelain_def.tiles,
        groups = {cracky = 3},
        sounds = porcelain_def.sounds,
    })

    minetest.register_craft({
        type = "cooking",
        cooktime = 15,
        recipe = "porcelain:stained_clay_"..color, 
        output = porcelain_def.name,
    })

    if minetest.get_modpath("moreblocks") then
        stairsplus:register_all("porcelain", "porcelain_"..color, porcelain_def.name, {
            description = porcelain_def.description,
            tiles = porcelain_def.tiles,
            groups = {cracky = 3},
            sounds = porcelain_def.sounds,
            sunlight_propagates = true,
        })
    end
end