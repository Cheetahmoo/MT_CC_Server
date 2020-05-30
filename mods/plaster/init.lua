-----------------------------------------------------------------------------
--                              SETTINGS
----------------------------------------------------------------------------
--sounds
local function node_sound_plaster()
	local table = {}
	table.footstep = {name = "plaster_footstep", gain = 0.3, }
	table.dug = {name = "default_sand_footstep", gain = 1.0}
	table.place = {name = "default_place_node_hard", gain = 1.0}
	--default.node_sound_defaults(table)
	return table
end

local plaster_colors = {
	"red", "dark_red", "brown", "dark_brown", "orange", "dark_orange", "yellow", "dark_yellow", "avocado", "dark_avocado", "green", "dark_green", "cyan", "dark_cyan",
	"blue", "dark_blue", "violet", "dark_violet", "white", "black", "grey", "dark_grey",
}

local dyes = {"magenta", "red", "orange", "brown", "yellow", "green", "dark_green", "cyan", "blue", "violet", "black", "dark_grey", "grey", "white"}

local plaster_mixes = {
	--                  magenta,       red,           orange,        brown,         yellow,        green,         dark_green,    cyan,         blue,          violet,        black,        dark_grey,     grey,        white
	["mortar"]      = {"red",         "red",         "orange",      "brown",       "yellow",      "avocado",     "dark_green",  "cyan",        "blue",        "violet",      "black",       "dark_grey",   "grey",      "white"},
	["red"]         = {"dark_red",    "dark_red",    "dark_brown",  "dark_brown",  "orange",      "brown",       "dark_brown",  "violet",      "violet",      "violet",      "dark_red",    "dark_red",    "grey",      "white"},
	["dark_red"]    = {"dark_red",    "dark_red",    "dark_brown",  "dark_brown",  "dark_orange", "dark_brown",  "dark_brown",  "violet",      "dark_violet", "dark_violet", "black",       "dark_grey",   "red",       "red"},
	["brown"]       = {"red",         "red",         "orange",      "dark_brown",  "yellow",      "dark_orange", "dark_green",  "dark_green",  "dark_violet", "dark_violet", "dark_brown",  "dark_brown",  "grey",      "white"},
	["dark_brown"]  = {"dark_red",    "dark_red",    "dark_orange", "dark_brown",  "orange",      "dark_brown",  "dark_brown",  "dark_brown",  "dark_violet", "dark_red",    "black",       "dark_grey",   "brown",     "brown"},
	["orange"]      = {"dark_red",    "dark_red",    "dark_orange", "dark_orange", "dark_orange", "avocado",     "dark_avocado","green",       "dark_green",  "dark_cyan",   "dark_orange", "dark_orange", "grey",      "white"},
	["dark_orange"] = {"dark_brown",  "dark_brown",  "dark_orange", "dark_orange", "orange",      "dark_brown",  "dark_brown",  "dark_brown",  "dark_violet", "dark_violet", "black",       "dark_grey",   "orange",    "orange"},
	["yellow"]      = {"orange",      "orange",      "dark_yellow", "brown",       "dark_yellow", "avocado",     "dark_avocado","dark_avocado","dark_green",  "dark_brown",  "dark_yellow", "dark_yellow", "grey",      "white"},
	["dark_yellow"] = {"dark_orange", "dark_orange", "dark_orange", "dark_orange", "dark_yellow", "dark_avocado","dark_avocado","dark_green",  "dark_green",  "dark_brown",  "black",       "dark_grey",   "yellow",    "yellow"},
	["avocado"]     = {"dark_brown",  "dark_brown",  "dark_brown",  "dark_brown",  "dark_yellow", "dark_avocado","dark_green",  "dark_green",  "dark_green",  "dark_cyan",   "dark_avocado","dark_avocado","grey",      "white"},
	["dark_avocado"]= {"dark_brown",  "dark_brown",  "dark_brown",  "dark_brown",  "dark_orange", "dark_green",  "dark_green",  "dark_cyan",   "dark_cyan",   "dark_blue",   "black",       "dark_grey",   "avocado",   "avocado"},
	["green"]       = {"dark_brown",  "dark_brown",  "dark_brown",  "dark_brown",  "avocado",     "dark_green",  "dark_green",  "dark_cyan",   "dark_cyan",   "dark_blue",   "dark_green",  "dark_green",  "grey",      "white"},
	["dark_green"]  = {"dark_brown",  "dark_brown",  "dark_brown",  "dark_brown",  "dark_avocado","dark_green",  "dark_green",  "dark_cyan",   "dark_cyan",   "dark_blue",   "black",       "dark_grey",   "green",     "green"},
	["cyan"]        = {"violet",      "violet",      "brown",       "dark_brown",  "green",       "green",       "dark_cyan",   "dark_cyan",   "dark_blue",   "dark_blue",   "dark_cyan",   "dark_cyan",   "grey",      "white"},
	["dark_cyan"]   = {"dark_violet", "dark_violet", "dark_brown",  "dark_violet", "dark_green",  "dark_green",  "dark_green",  "dark_cyan",   "dark_blue",   "dark_blue",   "black",       "dark_grey",   "cyan",      "cyan"},
	["blue"]        = {"dark_violet", "dark_violet", "violet",      "dark_violet", "green",       "cyan",        "dark_cyan",   "dark_blue",   "dark_blue",   "dark_violet", "dark_blue",   "dark_blue",   "grey",      "white"},
	["dark_blue"]   = {"dark_violet", "dark_violet", "dark_brown",  "dark_brown",  "dark_green",  "dark_cyan",   "dark_cyan",   "dark_blue",   "dark_blue",   "dark_violet", "black",       "dark_grey",   "blue",      "blue"},
	["violet"]      = {"red",         "red",         "cyan",        "dark_cyan",   "green",       "brown",       "dark_brown",  "blue",        "dark_violet", "dark_violet", "dark_violet", "dark_violet", "grey",      "white"},
	["dark_violet"] = {"dark_red",    "dark_red",    "dark_cyan",   "dark_cyan",   "blue",        "dark_brown",  "dark_brown",  "dark_blue",   "dark_blue",   "dark_violet", "black",       "dark_grey",   "violet",    "violet"},
	["white"]       = {"red",         "red",         "orange",      "brown",       "yellow",      "avocado",     "dark_green",  "cyan",        "blue",        "violet",      "black",       "dark_grey",   "grey",      "white"},
	["black"]       = {"dark_red",    "dark_red",    "dark_orange", "dark_brown",  "dark_yellow", "dark_green",  "dark_green",  "dark_cyan",   "dark_blue",   "dark_violet", "black",       "black",       "dark_grey", "grey"},
	["grey"]        = {"red",         "red",         "orange",      "brown",       "yellow",      "avocado",     "dark_green",  "cyan",        "blue",        "violet",      "black",       "dark_grey",   "grey",      "grey"},
	["dark_grey"]   = {"dark_red",    "dark_red",    "dark_orange", "dark_brown",  "dark_yellow", "dark_green",  "dark_green",  "dark_cyan",   "dark_blue",   "dark_violet", "black",       "black",       "grey",      "grey"},
}

----------------------------------------------------------------------------
--                      PLASTER REGISTRATION
----------------------------------------------------------------------------

for i, color in ipairs(plaster_colors) do
	--Plaster Definition
	local desc = string.gsub(color, "_", " "):gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
	local def = {
		name = "plaster:plaster_"..color,
		description = desc.." Plaster",
		inv_img = "plaster_"..color..".png",
        tiles = {{name = "plaster_plaster.png^plaster_"..color..".png", align_style = "world", scale = 4}},
		sounds = node_sound_plaster(),
	}
	--Register Plaster
	minetest.register_node(def.name, {
		description = def.description,
		inventorycube =  minetest.inventorycube(def.inv_img.."&[sheet:4x4:1,1", def.inv_img.."&[sheet:4x4:1,1", def.inv_img.."&[sheet:4x4:1,1"),
        tiles = def.tiles,
        groups = {crumbly = 2},
        sounds = def.sounds,
	})
	--Make cuttable
	if minetest.get_modpath("moreblocks") then
        stairsplus:register_all("plaster", "plaster_"..color, def.name, {
            description = def.description,
			tiles = def.tiles,
            groups = {crumbly = 2}, --cannot use plaster_def because stairsplus:register_all adds not_in_creative_inventory to the groups reference
            sounds = def.sounds,
            sunlight_propagates = true,
        })
	end
	--Create recipies
	for j, result in ipairs(plaster_mixes[color]) do
		minetest.register_craft({
			type = "shapeless",
			output = "plaster:plaster_"..result,
			recipe = {"dye:"..dyes[j], def.name}
		})
	end
end

----------------------------------------------------------------------------
--                         MORTAR
----------------------------------------------------------------------------
minetest.register_craftitem("plaster:mortar", {
	description = "Mortar",
	inventory_image = ("plaster_morter.png"),
	groups = {lump = 3},
})

minetest.register_craft({
	output = 'plaster:mortar',
	recipe = {
		{'default:dirt','default:sand',''},		
		{'default:sand','default:dirt',''},
	}
})

for i, output in ipairs(plaster_mixes["mortar"]) do
	minetest.register_craft({
		type = "shapeless",
		output = "plaster:plaster_"..output,
		recipe = {"dye:"..dyes[i], "plaster:mortar"}
	})
end