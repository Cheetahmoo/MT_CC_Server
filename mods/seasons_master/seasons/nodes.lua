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
	grass = grassDefault
	dirt_with_snow = dirt_with_snowNotWinter
elseif seasons.season == "fall" then
	jungleLeaves = jungleFall
	acacia_leaves = acaciaFall
	leaves = leavesFall
	grass = grassDefault
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

--[[
--Reregistered Nodes
if (seasons.season == "spring") then
	minetest.register_node(":flowers:mushroom_fertile_red", {
		description = "Red Fertile Mushroom",
		tiles = {"flowers_mushroom_red.png"},
		inventory_image = "flowers_mushroom_red.png",
		wield_image = "flowers_mushroom_red.png",
		drawtype = "plantlike",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 3, attached_node = 1,
			not_in_creative_inventory = 1},
		drop = {
			items = {
				{items = {"flowers:mushroom_red_"}},
				{items = {"flowers:mushroom_spores_red"}, rarity = 4},
				{items = {"flowers:mushroom_spores_red"}, rarity = 2},
				{items = {"flowers:mushroom_spores_red"}, rarity = 2}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
		on_use = minetest.item_eat(5),
		selection_box = {
			type = "fixed",
			fixed = {-0.3, -0.5, -0.3, 0.3, 0, 0.3}
		}
	})
end
if seasons.season ~= "winter" then	
	minetest.register_node(":default:ice", {
		description = "Water Source",
		inventory_image = minetest.inventorycube("default_water.png"),
		drawtype = "liquid",
		tiles = {
			{
				name = "default_water_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
			},
		},
		special_tiles = {
			-- New-style water source material (mostly unused)
			{
				name = "default_water_source_animated.png",
				animation = {
					type = "vertical_frames",
					aspect_w = 16,
					aspect_h = 16,
					length = 2.0,
				},
				backface_culling = false,
			},
		},
		alpha = 160,
		paramtype = "light",
		walkable = false,
		pointable = false,
		diggable = false,
		buildable_to = true,
		is_ground_content = false,
		drop = "",
		drowning = 1,
		liquidtype = "source",
		liquid_alternative_flowing = "default:water_flowing",
		liquid_alternative_source = "default:water_source",
		liquid_viscosity = 1,
		post_effect_color = {a = 120, r = 30, g = 60, b = 90},
		groups = {water = 3, liquid = 3, puts_out_fire = 1},
	})
		--reregisters----

	minetest.register_node(":default:dirt_with_snow", {
		description = "Dirt with Grass",
		tiles = {"default_grass.png", "default_dirt.png",
			{name = "default_dirt.png^default_grass_side.png",
				tileable_vertical = false}},
		groups = {crumbly = 3, soil = 1},
		drop = 'default:dirt',
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
	})
	minetest.register_node(":default:snow", {
		description = "Snow",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drawtype = "glasslike_framed_optional",
		tiles = {"seasons_snowAlpha.png"},
		inventory_image = "default_snowball.png",
		--diggable = false,
		paramtype = "light",
		legacy_mineral = true,
		pointable = false,
		groups = {cracky = 3, stone = 1, not_in_creative_inventory=1},
	})

	minetest.register_node(":default:snowblock", {
		description = "Snow Block",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drawtype = "glasslike_framed_optional",
		tiles = {"seasons_snowAlpha.png"},
		inventory_image = minetest.inventorycube("default_snow.png"),
		--diggable = false,
		paramtype = "light",
		legacy_mineral = true,
		pointable = false,
		groups = {cracky = 3, stone = 1, not_in_creative_inventory=1},
	})
end

local signs = {
	{delta = {x = 0, y = 0, z = 0}, yaw = 0},
	{delta = {x = 0, y = 0, z = 0}, yaw = math.pi / -2},
	{delta = {x = 0, y = 0, z = 0}, yaw = math.pi},
	{delta = {x = 0, y = 0, z = 0}, yaw = math.pi / 2},
}
minetest.register_node("seasons:pressure_gauge", {
	description = "Pressure Gauge",
	tiles = {"heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher.png"	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, 0.4375, 0.5, 0.5, 0.5}, -- NodeBox1
		}
	},

	groups = {choppy=2, dig_immediate=2, heat = 1},
	on_place = function(itemstack, placer, pointed_thing)
		local above = pointed_thing.above
		local under = pointed_thing.under
		local dir = {x = under.x - above.x, y = under.y - above.y, z = under.z - above.z}
		local placer_pos = placer:getpos()

		if placer_pos then
			dir = {x = above.x - placer_pos.x, y = above.y - placer_pos.y, z = above.z - placer_pos.z}
		end

		local fdir = minetest.dir_to_facedir(dir)
		local sign_info
		print (minetest.env:get_node(above).name)
	
			minetest.env:add_node(above, {name = "seasons:pressure_gauge_inside", param2 = fdir})
			sign_info = signs[fdir + 1]
		
		local text = minetest.env:add_entity(  {x = above.x + sign_info.delta.x,
												y = above.y + sign_info.delta.y,
												z = above.z + sign_info.delta.z}, "signs:text")
		text:setyaw(sign_info.yaw)

		itemstack:take_item()
		return itemstack
	end,
	on_construct = function(pos)
		signsLua.construct_sign(pos, true)
	end,
	on_destruct = function(pos)
		signsLua.destruct_sign(pos)
	end,
	on_punch = function(pos, node, puncher)
		signsLua.update_sign(pos)
	end,
})
minetest.register_node("seasons:pressure_gauge_inside", {
	description = "Pressure Gauge",
	tiles = {"heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher.png"	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, 0, 0.375, 7.45058e-009, 0.125, 1.6}, -- NodeBox1
			{-0.3125, 0, 0.375, 0.1875, 0.5, 0.5}, -- NodeBox2
		}
	},

	groups = {choppy=2, dig_immediate=2, heat = 1},
	on_place = function(itemstack, placer, pointed_thing)
		local above = pointed_thing.above
		local under = pointed_thing.under
		local dir = {x = under.x - above.x, y = under.y - above.y, z = under.z - above.z}
		local placer_pos = placer:getpos()

		if placer_pos then
			dir = {x = above.x - placer_pos.x, y = above.y - placer_pos.y, z = above.z - placer_pos.z}
		end

		local fdir = minetest.dir_to_facedir(dir)
		local sign_info
		print (minetest.env:get_node(above).name)
	
			minetest.env:add_node(above, {name = "seasons:pressure_gauge_inside", param2 = fdir})
			sign_info = signs[fdir + 1]
		
		local text = minetest.env:add_entity(  {x = above.x + sign_info.delta.x,
												y = above.y + sign_info.delta.y,
												z = above.z + sign_info.delta.z}, "signs:text")
		text:setyaw(sign_info.yaw)

		itemstack:take_item()
		return itemstack
	end,
	on_construct = function(pos)
		signsLua.construct_sign(pos, true)
	end,
	on_destruct = function(pos)
		signsLua.destruct_sign(pos)
	end,
	on_punch = function(pos, node, puncher)
		signsLua.update_sign(pos)
	end,
})


minetest.register_node("seasons:pressure_gauge", {
	description = "Pressure Gauge",
	tiles = {"heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher.png"	},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.312, 0, 0.4375, 0.187, 0.5, 0.5},
		}
	},
	groups = {choppy=2, dig_immediate=2, heat = 1},

	on_construct = function(pos)
		signsLua.construct_sign(pos, true)
	end,
	on_destruct = function(pos)
		signsLua.destruct_sign(pos)
	end,
	on_punch = function(pos, node, puncher)
		minetest.swap_node(pos, {name = "seasons:pressure_gauge_inside", param2 = node.param2})
	end,
})
minetest.register_node("seasons:pressure_gauge_inside", {
	description = "Pressure Gauge Inside",
	tiles = {"heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher1.png","heat_Presher_inside.png"},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, 0, 0.437500, 7.45058e-009, 0.125, 1.6}, -- NodeBox1
			{-0.3125, 0, 0.437500, 0.1875, 0.5, 0.5}, -- NodeBox2
		}
	},
	groups = {choppy=2, dig_immediate=2},

	on_construct = function(pos)
		signsLua.construct_sign(pos, true)
	end,
	on_destruct = function(pos)
		signsLua.destruct_sign(pos)
	end,
	on_punch = function(pos, node, puncher)
		minetest.swap_node(pos, {name = "seasons:pressure_gauge", param2 = node.param2})
	end,
})

--
if(seasons.season == "winter") then
	minetest.register_node(":default:junglegrass", {
		description = "Jungle Grass",
		drawtype = "plantlike",
		waving = 1,
		tiles = {"seasons_junglegrass.png"},
		inventory_image = "seasons_junglegrass.png",
		wield_image = "seasons_junglegrass.png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
	})
	minetest.register_node(":default:dirt_with_grass", {
		description = "Dirt with Snow",
		tiles = {"default_snow.png", "default_dirt.png",
			{name = "default_dirt.png^default_snow_side.png",
				tileable_vertical = false}},
		groups = {crumbly = 3, soil = 1},
		drop = 'default:dirt',
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_snow_footstep", gain = 0.25},
		}),
	})
end
minetest.register_node("seasons:pine_needles",{
	description = "Pine Needles",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	walkable = false,
	tiles = {"default_pine_needles.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"default:pine_sapling"}, rarity = 20},
			{items = {"default:pine_needles"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})

if seasons.season ~= "summer" then
		
	minetest.register_node(":default:dirt_with_grass", {
		description = "Dirt with Grass",
		tiles = {grass[1], "default_dirt.png",
			{name = "default_dirt.png^" .. grass[2],
				tileable_vertical = false}},
		groups = {crumbly = 3, soil = 1},
		drop = 'default:dirt',
		sounds = default.node_sound_dirt_defaults({
			footstep = {name = "default_grass_footstep", gain = 0.25},
		}),
		soil = {
			base = "default:dirt_with_grass",
			dry = "farming:soil",
			wet = "farming:soil_wet"
		}
	})
 	minetest.register_node(":default:jungleleaves", {
		description = "Jungle Leaves",
		drawtype = "allfaces_optional",
		waving = 1,
		walkable = false,
		visual_scale = 1.3,
		tiles = {jungleLeaves[1]},
		special_tiles = {jungleLeaves[2]},
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
		drop = {
			max_items = 1,
			items = {
				{items = {'default:junglesapling'}, rarity = 20},
				{items = {'default:jungleleaves'}}
			}
		},
		sounds = default.node_sound_leaves_defaults(),

		after_place_node = default.after_place_leaves,
	})
	minetest.register_node(":default:leaves", {
		description = "Leaves",
		drawtype = "allfaces_optional",
		waving = 1,
		walkable = false,
		visual_scale = 1.3,
		tiles = {leaves[1]},
		special_tiles = {leaves[2]},
		paramtype = "light",
		is_ground_content = false,
		groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
		drop = {
			max_items = 1,
			items = {
				{
					-- player will get sapling with 1/20 chance
					items = {'default:sapling'},
					rarity = 20,
				},
				{
					-- player will get leaves only if he get no saplings,
					-- this is because max_items is 1
					items = {'default:leaves'},
				}
			}
		},
		sounds = default.node_sound_leaves_defaults(),

		after_place_node = default.after_place_leaves,
	})
end



--Ice-----


--
--Bad Apples



-- Jungle Leaves
--
---Winter
minetest.register_node("seasons:jungleleaves_winter", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	walkable = false,
	visual_scale = 1.3,
	tiles = {jungleLeaves[1]},
	special_tiles = {jungleLeaves[2]},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
---spring
minetest.register_node("seasons:jungleleaves_spring", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	walkable = false,
	visual_scale = 1.3,
	tiles = {jungleLeaves[1]},
	special_tiles = {jungleLeaves[2]},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
---Fall
minetest.register_node("seasons:jungleleaves_fall", {
	description = "Jungle Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	walkable = false,
	visual_scale = 1.3,
	tiles = {jungleLeaves[1]},
	special_tiles = {jungleLeaves[2]},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:junglesapling'}, rarity = 20},
			{items = {'default:jungleleaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
--]]
-- Normal Leaves
--
---Winter

--[[spring
minetest.register_node("seasons:leaves_spring", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	walkable = false,
	visual_scale = 1.3,
	tiles = {leaves[1]},
	special_tiles = {leaves[2]},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:sapling'}, rarity = 20},
			{items = {'default:leaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
---Fall
minetest.register_node("seasons:leaves_fall", {
	description = "Leaves",
	drawtype = "allfaces_optional",
	waving = 1,
	walkable = false,
	visual_scale = 1.3,
	tiles = {leaves[1]},
	special_tiles = {leaves[2]},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1, not_in_creative_inventory=1},
	drop = {
		max_items = 1,
		items = {
			{items = {'default:sapling'}, rarity = 20},
			{items = {'default:leaves'}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = default.after_place_leaves,
})
--]]
minetest.register_node("seasons:soil_wet_frozen", {
	tiles = {"default_dirt.png^winter_farming_soil_wet.png", "default_dirt.png^winter_farming_soil_wet_side.png"},
	drop = "default:dirt",
	groups = {crumbly=3, not_in_creative_inventory=1},
	sounds = default.node_sound_dirt_defaults(),
})
