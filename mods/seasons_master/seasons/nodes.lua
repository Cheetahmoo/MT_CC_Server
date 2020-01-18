--
--texture
--

--[[Jungle Leaves]]
local jungleWinter = {"jungleleaves_winter.png","jungleleaves_winter_simple.png"}
local jungleDefault = {"default_jungleleaves.png","default_jungleleaves_simple.png"}
local junglespring = {"spring_jungleleaves.png","spring_jungleleaves_simple.png"}
local jungleFall = {"fall_jungleleaves.png","fall_jungleleaves_simple.png"}
local jungleLeaves = jungleDefault

--[[default Leaves]]
local leavesWinter = {"leaves_winter.png","leaves_simple_winter.png"}
local leavesDefault = {"default_leaves.png","default_leaves_simple.png"}
local leavesspring = {"spring_leaves.png","spring_leaves_simple.png"}
local leavesFall = {"fall_leaves.png","fall_leaves_simple.png"}
local leaves = leavesDefault

--[[default acacia]]
local acaciaWinter = {"leaves_winter.png","leaves_simple_winter.png"}
local acaciaDefault = {"default_acacia_leaves.png","default_leaves_simple.png"}
local acaciaSpring = {"default_acacia_leaves.png","default_leaves_simple.png"}
local acaciaFall = {"acacia_leaves_fall.png","acacia_leaves_fall_simple.png"}
local acacia_leaves = acaciaDefault

--[[dirt_with_grass]]--
local grassWinter = {"default_snow.png", "default_dirt.png",{name = "default_dirt.png^default_snow_side.png",tileable_vertical = false}}
local grassSpring = {"seasons_grass_spring.png", "default_dirt.png",{name = "default_dirt.png^seasons_grass_side_spring.png",tileable_vertical = false}}
local grassFall = {"seasons_grass_fall.png", "default_dirt.png",{name = "default_dirt.png^seasons_grass_side_fall.png",tileable_vertical = false}}
local grassDefault = {"default_grass.png", "default_dirt.png",{name = "default_dirt.png^default_grass_side.png",tileable_vertical = false}}
local grass = grassDefault

--[[dirt_with_grass]]--
local dirt_with_snowNotWinter = {"default_grass.png", "default_dirt.png",{name = "default_dirt.png^default_grass_side.png",tileable_vertical = false}}
local dirt_with_snowDefault = {"default_snow.png", "default_dirt.png",{name = "default_dirt.png^default_snow_side.png",tileable_vertical = false}}
local dirt_with_snow = dirt_with_snowDefault

if(seasons.season == "winter") then
	jungleLeaves = jungleWinter
	acacia_leaves = acaciaWinter
	leaves = leavesWinter
	grass = grassWinter
	dirt_with_snow = dirt_with_snowDefault
elseif seasons.season == "spring" then 
	jungleLeaves = junglespring
	acacia_leaves = acaciaSpring
	leaves = leavesspring
	grass = grassSpring
	dirt_with_snow = dirt_with_snowNotWinter
elseif seasons.season == "fall" then
	jungleLeaves = jungleFall
	acacia_leaves = acaciaFall
	leaves = leavesFall
	grass = grassFall
	dirt_with_snow = dirt_with_snowNotWinter
else
	jungleLeaves = jungleDefault
	acacia_leaves = acaciaDefault
	leaves = leavesDefault
	grass = grassDefault
	dirt_with_snow = dirt_with_snowNotWinter
end

--
-- Alias
--

----NONE

--
-- Plants
--

--Non Damaging Mushroom
minetest.register_node("seasons:mushroom_red", {
	description = "Red Mushroom",
	drawtype = "plantlike",
	tiles = {"flowers_mushroom_red.png"},
	inventory_image = "flowers_mushroom_red.png",
	wield_image = "flowers_mushroom_red.png",	
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flammable = 3, attached_node = 1, not_in_creative_inventory=1},
	sounds = default.node_sound_leaves_defaults(),
	on_use = minetest.item_eat(5),
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3}
	}
})



--
--Nodes
--
minetest.register_node("seasons:ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	paramtype = "light",
	groups = {cracky = 3, cools_lava = 1, slippery = 3, snow_cover = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("seasons:flowing_ice", {
	description = "Ice",
	tiles = {"default_ice.png"},
	is_ground_content = false,
	drop = "seasons:ice",
	groups = {cracky = 3, cools_lava = 1, slippery = 3, snow_cover = 1, not_in_creative_inventory = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.override_item("default:ice", {
	drop = "seasons:ice"
})

if seasons.season == "winter" then
	--water
	minetest.override_item("default:water_source", {
		groups = {water = 3, liquid = 3, cools_lava = 1, Coolplayer = 5},
	})
	minetest.override_item("default:water_flowing", {
		groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1, Coolplayer = 5},
	})
	minetest.override_item("default:river_water_source", {
		groups = {water = 3, liquid = 3, cools_lava = 1, Coolplayer = 5},
	})
	minetest.override_item("default:river_water_flowing", {
		groups = {water = 3, liquid = 3, not_in_creative_inventory = 1,
		cools_lava = 1, Coolplayer = 5},
	})


	--Red Mushroom
	minetest.override_item("flowers:mushroom_fertile_red", {
		drop = {
			items = {
				{items = {"flowers:mushroom_red_"}},
				{items = {"flowers:mushroom_spores_red"}, rarity = 4},
				{items = {"flowers:mushroom_spores_red"}, rarity = 2},
				{items = {"flowers:mushroom_spores_red"}, rarity = 2}
			}
		}
	})
	--grasses
	minetest.override_item("default:grass_1", {
		tiles = {"season_grass_1.png"},
		inventory_image = "season_grass_1.png",
		wield_image = "season_grass_1.png",
	})

	for i = 2, 5 do
		minetest.override_item("default:grass_" .. i, {
			
			tiles = {"season_grass_" .. i .. ".png"},
			inventory_image = "season_grass_" .. i .. ".png",
			wield_image = "season_grass_" .. i .. ".png",
		})
	end
	--Papyrus 
	minetest.override_item("default:papyrus", {
		tiles = {"seasons_papyrus.png"},
		inventory_image="seasons_papyrus.png",
		wield_image="seasons_papyrus.png",
	})
	--Cactus 
	minetest.override_item("default:cactus", {
		tiles = {"seasons_cactus_top.png", "seasons_cactus_top.png",
		"seasons_cactus_side.png"},
	})
	--Waterlily 
	minetest.override_item("flowers:waterlily", {
		tiles = {"seasons_waterlily.png"},
	})
	--Junglegrass 
	minetest.override_item("default:junglegrass", {
		tiles = {"seasons_winter_junglegrass.png"},
		inventory_image = "seasons_winter_junglegrass.png",
		wield_image = "seasons_winter_junglegrass.png",
	})
	--snow + snow blocks
	minetest.override_item("default:snowblock", {
		paramtype = "light",
		sunlight_propagates = true,
		groups = {fall_damage_add_percent = -40, crumbly = 3, puts_out_fire = 1}
	})
	minetest.override_item("default:snow", {
		groups = {fall_damage_add_percent = -25, crumbly = 3, falling_node = 1, puts_out_fire = 1}
	})
else
	minetest.override_item("default:dirt_with_snow", {
		tiles = dirt_with_snow,
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
	})
	minetest.override_item("default:snow", {
		inventory_image = "default_snowball.png",
		wield_image = "default_snowball.png",
		drawtype = "airlike",
		walkable = false,
		pointable = false,
	})
	minetest.override_item("default:snowblock", {
		inventory_image = minetest.inventorycube("default_snow.png"),
		wield_image = minetest.inventorycube("default_snow.png"),
		drawtype = "airlike",
		buildable_to = true,
		sunlight_propagates = true,
		paramtype = "light",
		walkable = false,
		pointable = false,
	})
end

if seasons.season == "fall" or seasons.season == "winter" or seasons.season == "spring" then
	minetest.override_item("default:leaves", {
		tiles = {leaves[1]},
		special_tiles = {leaves[2]},
	})
	minetest.override_item("default:jungleleaves", {
		tiles = {jungleLeaves[1]},
		special_tiles = {jungleLeaves[2]},
	})
	minetest.override_item("default:acacia_leaves", {
		tiles = {acacia_leaves[1]},
		special_tiles = {acacia_leaves[2]},
	})
	minetest.override_item("default:leaves", {
		tiles = {leaves[1]},
		special_tiles = {leaves[2]},
	})
	minetest.override_item("default:dirt_with_grass", {
		tiles = grass,
	})
end

minetest.register_node("seasons:apple_roten", {
	description = "Rotten Apple",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"rotten_apple.png"},
	inventory_image = "rotten_apple.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	is_ground_content = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
	},
	groups = {fleshy = 3, dig_immediate = 3, flammable = 2,	leafdecay = 3, leafdecay_drop = 1, not_in_creative_inventory=1},
	on_use = minetest.item_eat(5),
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name = "seasons:apple_roten", param2 = 1})
		end
	end,
})

minetest.register_node("seasons:soil_wet_frozen", {
	tiles = {"default_dirt.png^winter_farming_soil_wet.png", "default_dirt.png^winter_farming_soil_wet_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("seasons:desert_soil_wet_frozen", {
	tiles = {"farming_desert_sand_soil.png^winter_farming_soil_wet_side.png", "default_desert_sand.png^winter_farming_soil_wet_side.png"},
	drop = "default:desert_sand",
	groups = {cracky = 3, not_in_creative_inventory=1, farming_soil = 1},
	sounds = default.node_sound_glass_defaults(),
})
