--[[
More Blocks: registrations

Copyright (c) 2011-2015 Calinou and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

local default_nodes = { -- Default stairs/slabs/panels/microblocks:
	"stone",
	"cobble",
	"mossycobble",
	"brick",
	"sandstone",
	"steelblock",
	"goldblock",
	"copperblock",
	"bronzeblock",--Stoped at
	"diamondblock",
	"desert_stone",
	"desert_cobble",
	"meselamp",
	"glass",
	"tree",
	"wood",
	"jungletree",
	"junglewood",
	"pine_tree",
	"pine_wood",
	"aspen_tree",
	"aspen_wood",
	"acacia_wood",
	"obsidian",
	"obsidian_glass",
	"stonebrick",
	"desert_stonebrick",
	"sandstonebrick",
	"obsidianbrick",
	"ice"
}
--------Farming Nodes ------------
local farming_nodes = {
	"straw"
}
-------- Wool Nodes ------------
local wool_nodes = {
	"white",
	"grey",
	"black",
	"red",
	"yellow",
	"green",
	"cyan",
	"blue",
	"magenta",
	"orange",
	"violet",
	"brown",
	"pink",
	"dark_grey",
	"dark_green"
}
local plasters_init = {
	"plaster_raw",
	"plaster_green",
	"plaster_blue",
	"plaster_black",
	"plaster_dark_grey",
	"plaster_brown",
	"plaster_cyan",
	"plaster_dark_green",
	"plaster_magenta",
	"plaster_orange",
	"plaster_pink",
	"plaster_red",
	"plaster_violet",
	"plaster_yellow",
	"dad_block6"
}

local moretiles_init = {
	"western_stone",
	"western_stone_block",
	"eastern_stone",
	"eastern_stone_block",
}
local porcelain_init = {
	"orange_stained_stone",
	"cyan_stained_stone",
	"blue_stained_stone",
	"green_stained_stone",
	"yellow_stained_stone",
	"brown_stained_stone",
	"red_stained_stone",
	"orange_porcelain",
	"cyan_porcelain",
	"blue_porcelain",
	"green_porcelain",
	"yellow_porcelain",
	"red_porcelain",
	"brown_porcelain",
	"white_porcelain",

}
for _, name in pairs(porcelain_init) do
	local nodename = "porcelain:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end
for _, name in pairs(default_nodes) do
	local nodename = "default:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end

--Farmming
for _, name in pairs(farming_nodes) do
	local nodename = "farming:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end

--Wool--
for _, name in pairs(wool_nodes) do
	local nodename = "wool:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end

--Plaster
for _, name in pairs(plasters_init) do
	local nodename = "plasters:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end
for _, name in pairs(moretiles_init) do
	local nodename = "moretiles:" .. name
	local ndef = minetest.registered_nodes[nodename]
	if ndef then
		local groups = {}
		for k, v in pairs(ndef.groups)
			-- Ignore wood and stone groups to not make them usable in crafting:
			do if k ~= "wood" and k ~= "stone" and k ~= "snow_cover" then
				groups[k] = v
			end
		end
		local drop
		
		if type(ndef.drop) == "string" then
			drop = ndef.drop:sub(9)
		end
		stairsplus:register_all("moreblocks", name, nodename, {
			description = ndef.description,
			drop = drop,
			groups = groups,
			sounds = ndef.sounds,
			tiles = ndef.tiles,
			sunlight_propagates = true,
			light_source = ndef.light_source
		})
	end
end