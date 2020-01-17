----------------------------------------------------------------------------
--                       REGISTER WOOL AS STAINABLE
----------------------------------------------------------------------------
--Register wools as stainable nodes
local wool_col = {
    --Node to Stain        After Adding Red         After Adding Blue             After Adding Yellow             After Adding White            After Adding Black
    ["wool:white"]      = {["red"] = "wool:pink",   ["blue"] = "wool:cyan",       ["yellow"] = "wool:yellow",     ["white"] = "wool:white",     ["black"] = "wool:grey"},
    ["wool:grey"]       = {["red"] = "wool:pink",   ["blue"] = "wool:cyan",       ["yellow"] = "wool:yellow",     ["white"] = "wool:white",     ["black"] = "wool:dark_grey"},
    ["wool:dark_grey"]  = {["red"] = "wool:red",    ["blue"] = "wool:blue",       ["yellow"] = "wool:brown",      ["white"] = "wool:grey",      ["black"] = "wool:black"},
    ["wool:black"]      = {["red"] = "wool:black",  ["blue"] = "wool:black",      ["yellow"] = "wool:black",      ["white"] = "wool:dark_grey", ["black"] = "wool:black"},
    ["wool:red"]        = {["red"] = "wool:red",    ["blue"] = "wool:violet",     ["yellow"] = "wool:orange",     ["white"] = "wool:pink",      ["black"] = "wool:brown"},
    ["wool:yellow"]     = {["red"] = "wool:orange", ["blue"] = "wool:green",      ["yellow"] = "wool:yellow",     ["white"] = "wool:white",     ["black"] = "wool:brown"},
    ["wool:green"]      = {["red"] = "wool:brown",  ["blue"] = "wool:cyan",       ["yellow"] = "wool:yellow",     ["white"] = "wool:yellow",    ["black"] = "wool:dark_green"},
    ["wool:cyan"]       = {["red"] = "wool:violet", ["blue"] = "wool:blue",       ["yellow"] = "wool:green",      ["white"] = "wool:white",     ["black"] = "wool:blue"},
    ["wool:blue"]       = {["red"] = "wool:violet", ["blue"] = "wool:blue",       ["yellow"] = "wool:dark_green", ["white"] = "wool:cyan",      ["black"] = "wool:blue"},
    ["wool:magenta"]    = {["red"] = "wool:red",    ["blue"] = "wool:violet",     ["yellow"] = "wool:orange",     ["white"] = "wool:pink",      ["black"] = "wool:brown"},
    ["wool:orange"]     = {["red"] = "wool:red",    ["blue"] = "wool:dark_green", ["yellow"] = "wool:yellow",     ["white"] = "wool:yellow",    ["black"] = "wool:brown"},
    ["wool:violet"]     = {["red"] = "wool:red",    ["blue"] = "wool:blue",       ["yellow"] = "wool:dark_green", ["white"] = "wool:magenta",   ["black"] = "wool:black"},
    ["wool:brown"]      = {["red"] = "wool:brown",  ["blue"] = "wool:brown",      ["yellow"] = "wool:orange",     ["white"] = "wool:orange",    ["black"] = "wool:black"},
    ["wool:pink"]       = {["red"] = "wool:red",    ["blue"] = "wool:magenta",    ["yellow"] = "wool:orange",     ["white"] = "wool:white",     ["black"] = "wool:grey"},
    ["wool:dark_green"] = {["red"] = "wool:brown",  ["blue"] = "wool:dark_green", ["yellow"] = "wool:green",      ["white"] = "wool:green",     ["black"] = "wool:black"},
}
for name, effects in pairs(wool_col) do
    if minetest.registered_nodes[name] then
        minetest.clear_craft({output = name})
        oil_stains.register_stainable_node(name, effects)
    end
end


----------------------------------------------------------------------------
--                       REGISTER PLASTER AS STAINABLE
----------------------------------------------------------------------------
--Register plasters as stainable nodes
local plaster_col = {
    --Node to Stain
    ["plaster:plaster_red"] = {
        ["red"]    = "plaster:plaster_dark_red",
        ["blue"]   = "plaster:plaster_violet",
        ["yellow"] = "plaster:plaster_orange",
        ["black"]  = "plaster:plaster_dark_red",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_red"] = {
        ["red"]    = "plaster:plaster_dark_red",
        ["blue"]   = "plaster:plaster_dark_violet",
        ["yellow"] = "plaster:plaster_dark_orange",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_red",
    },
    ["plaster:plaster_brown"] = {
        ["red"]    = "plaster:plaster_red", 
        ["blue"]   = "plaster:plaster_blue",
        ["yellow"] = "plaster:plaster_yellow", 
        ["black"]  = "plaster:plaster_grey",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_brown"] = {
        ["red"]    = "plaster:plaster_dark_red", 
        ["blue"]   = "plaster:plaster_dark_grey",
        ["yellow"] = "plaster:plaster_dark_orange", 
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_brown",
    },
    ["plaster:plaster_orange"] = {
        ["red"]    = "plaster:plaster_red", 
        ["blue"]   = "plaster:plaster_grey",
        ["yellow"] = "plaster:plaster_yellow",
        ["black"]  = "plaster:plaster_dark_orange",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_orange"] = {
        ["red"]    = "plaster:plaster_dark_red", 
        ["blue"]   = "plaster:plaster_dark_grey",
        ["yellow"] = "plaster:plaster_dark_yellow",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_orange",
    },
    ["plaster:plaster_yellow"] = {
        ["red"]    = "plaster:plaster_orange",
        ["blue"]   = "plaster:plaster_avocado",
        ["yellow"] = "plaster:plaster_dark_yellow", 
        ["black"]  = "plaster:plaster_dark_yellow",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_yellow"] = {
        ["red"]    = "plaster:plaster_dark_orange",
        ["blue"]   = "plaster:plaster_dark_avocado",
        ["yellow"] = "plaster:plaster_dark_yellow", 
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_yellow",
    },
    ["plaster:plaster_avocado"] = {
        ["red"]    = "plaster:plaster_brown",
        ["blue"]   = "plaster:plaster_dark_green",
        ["yellow"] = "plaster:plaster_yellow", 
        ["black"]  = "plaster:plaster_dark_avocado",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_avocado"] = {
        ["red"]    = "plaster:plaster_dark_brown",
        ["blue"]   = "plaster:plaster_dark_green",
        ["yellow"] = "plaster:plaster_avocado", 
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_avocado",
    },
    ["plaster:plaster_green"] = {
        ["red"]    = "plaster:plaster_brown",
        ["blue"]   = "plaster:plaster_dark_green",
        ["yellow"] = "plaster:plaster_avocado",
        ["black"]  = "plaster:plaster_dark_green",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_green"] = {
        ["red"]    = "plaster:plaster_brown",
        ["blue"]   = "plaster:plaster_cyan",
        ["yellow"] = "plaster:plaster_avocado",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_green",
    },
    ["plaster:plaster_cyan"] = {
        ["red"]    = "plaster:plaster_brown",
        ["blue"]   = "plaster:plaster_dark_blue",
        ["yellow"] = "plaster:plaster_green",
        ["black"]  = "plaster:plaster_dark_cyan",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_cyan"] = {
        ["red"]    = "plaster:plaster_dark_brown",
        ["blue"]   = "plaster:plaster_dark_blue",
        ["yellow"] = "plaster:plaster_dark_green",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_cyan",
    },
    ["plaster:plaster_blue"] = {
        ["red"]    = "plaster:plaster_violet",
        ["blue"]   = "plaster:plaster_dark_blue",
        ["yellow"] = "plaster:plaster_cyan",
        ["black"]  = "plaster:plaster_dark_blue",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_blue"] = {
        ["red"]    = "plaster:plaster_dark_violet",
        ["blue"]   = "plaster:plaster_dark_blue",
        ["yellow"] = "plaster:plaster_dark_cyan",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_blue",
    },
    ["plaster:plaster_violet"] = {
        ["red"]    = "plaster:plaster_red",
        ["blue"]   = "plaster:plaster_blue",
        ["yellow"] = "plaster:plaster_brown",
        ["black"]  = "plaster:plaster_dark_violet",
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_violet"] = {
        ["red"]    = "plaster:plaster_dark_red",
        ["blue"]   = "plaster:plaster_dark_blue",
        ["yellow"] = "plaster:plaster_dark_brown",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_violet",
    },
    ["plaster:plaster_white"] = {
        ["red"]    = "plaster:plaster_red", 
        ["blue"]   = "plaster:plaster_blue", 
        ["yellow"] = "plaster:plaster_yellow", 
        ["black"]  = "plaster:plaster_grey", 
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_black"] = {
        ["red"]    = "plaster:plaster_black",
        ["blue"]   = "plaster:plaster_black", 
        ["yellow"] = "plaster:plaster_black",
        ["black"]  = "plaster:plaster_black",
        ["white"]  = "plaster:plaster_dark_grey",
    },
    ["plaster:plaster_grey"] = {
        ["red"]    = "plaster:plaster_red",
        ["blue"]   = "plaster:plaster_blue", 
        ["yellow"] = "plaster:plaster_yellow",
        ["black"]  = "plaster:plaster_dark_grey", 
        ["white"]  = "plaster:plaster_white",
    },
    ["plaster:plaster_dark_grey"] = {
        ["red"]    = "plaster:plaster_black",
        ["blue"]   = "plaster:plaster_black",
        ["yellow"] = "plaster:plaster_grey",
        ["black"]  = "plaster:plaster_black", 
        ["white"]  = "plaster:plaster_grey",
    },
}
for name, effects in pairs(plaster_col) do
    if minetest.registered_nodes[name] then
        minetest.clear_craft({output = name})
        oil_stains.register_stainable_node(name, effects)
    end
end

--Add method to craft white plaster
minetest.register_craft({
	output = "plaster:plaster_brown 4",
	recipe = {
		{"plaster:mortar", "plaster:mortar"},
		{"plaster:mortar", "plaster:mortar"},
	}
})

----------------------------------------------------------------------------
--                       REGISTER CLAYS AS STAINABLE
----------------------------------------------------------------------------
--Register clays as stainable nodes (from PORCELAIN mod)
local clay_col = {
    ["porcelain:stained_clay_red"] = {
        ["red"]    = "porcelain:stained_clay_red",
        ["blue"]   = "porcelain:stained_clay_brown",
        ["yellow"] = "porcelain:stained_clay_orange",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_orange"] = {
        ["red"]    = "porcelain:stained_clay_red",
        ["blue"]   = "porcelain:stained_clay_brown",
        ["yellow"] = "porcelain:stained_clay_yellow",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_yellow"] = {
        ["red"]    = "porcelain:stained_clay_orange",
        ["blue"]   = "porcelain:stained_clay_avocado",
        ["yellow"] = "porcelain:stained_clay_yellow",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_avocado"] = {
        ["red"]    = "porcelain:stained_clay_brown",
        ["blue"]   = "porcelain:stained_clay_green",
        ["yellow"] = "porcelain:stained_clay_yellow",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_green"] = {
        ["red"]    = "porcelain:stained_clay_brown",
        ["blue"]   = "porcelain:stained_clay_cyan",
        ["yellow"] = "porcelain:stained_clay_avocado",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_cyan"] = {
        ["red"]    = "porcelain:stained_clay_brown",
        ["blue"]   = "porcelain:stained_clay_blue",
        ["yellow"] = "porcelain:stained_clay_green",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_blue"] = {
        ["red"]    = "porcelain:stained_clay_violet",
        ["blue"]   = "porcelain:stained_clay_blue",
        ["yellow"] = "porcelain:stained_clay_cyan",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_violet"] = {
        ["red"]    = "porcelain:stained_clay_red",
        ["blue"]   = "porcelain:stained_clay_blue",
        ["yellow"] = "porcelain:stained_clay_brown",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["default:clay"] = {
        ["red"]    = "porcelain:stained_clay_red",
        ["blue"]   = "porcelain:stained_clay_blue",
        ["yellow"] = "porcelain:stained_clay_yellow",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_white"] = {
        ["red"]    = "porcelain:stained_clay_red",
        ["blue"]   = "porcelain:stained_clay_blue",
        ["yellow"] = "porcelain:stained_clay_yellow",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_white",
    },
    ["porcelain:stained_clay_black"] = {
        ["red"]    = "porcelain:stained_clay_brown",
        ["blue"]   = "porcelain:stained_clay_brown",
        ["yellow"] = "porcelain:stained_clay_brown",
        ["black"]  = "porcelain:stained_clay_black",
        ["white"]  = "porcelain:stained_clay_brown",
    },
}
for name, effects in pairs(clay_col) do
    if minetest.registered_nodes[name] then
        minetest.clear_craft({output = name})
        oil_stains.register_stainable_node(name, effects)
    end
end