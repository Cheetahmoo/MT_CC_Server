
----------------------Stained Stone--------------
minetest.register_node("porcelain:orange_stained_stone", {
	description = "Orange Stained Stone",
	tiles = {"stone_stained_orange.png"},
	drop = 'default:cobble',
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:cyan_stained_stone", {
	description = "Cyan Stained Stone",
	tiles = {"stone_stained_cyan.png"},
	drop = 'default:cobble',
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:blue_stained_stone", {
	description = "Blue Stained Stone",
	tiles = {"stone_stained_blue.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:green_stained_stone", {
	description = "Green Stained Stone",
	tiles = {"stone_stained_green.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	drop = 'default:cobble',
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:yellow_stained_stone", {
	description = "Yellow Stained Stone",
	tiles = {"stone_stained_yellow.png"},
	drop = 'default:cobble',
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:red_stained_stone", {
	description = "Red Stained Stone",
	drop = 'default:cobble',
	tiles = {"stone_stained_red.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("porcelain:brown_stained_stone", {
	description = "Brown Stained Stone",
	tiles = {"stone_stained_brown.png"},
	drop = 'default:cobble',
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_stone_defaults(),
})
---------------------Porcelain-------------------
minetest.register_node("porcelain:orange_porcelain", {
	description = "Orange Porcelain",
	tiles = {"porcelain_orange.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:cyan_porcelain", {
	description = "Cyan Porcelain",
	tiles = {"porcelain_cyan.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:blue_porcelain", {
	description = "Blue Porcelain",
	tiles = {"porcelain_blue.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:green_porcelain", {
	description = "Green Porcelain",
	tiles = {"porcelain_green.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:yellow_porcelain", {
	description = "Yellow Porcelain",
	tiles = {"porcelain_yellow.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:red_porcelain", {
	description = "Red Porcelain",
	tiles = {"porcelain_red.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:brown_porcelain", {
	description = "Brown Porcelain",
	tiles = {"porcelain_brown.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:white_porcelain", {
	description = "White Porcelain",
	tiles = {"ivory.png"},
	groups = {cracky = 3, stone = 1, snow_cover = 1},
	sounds = default.node_sound_glass_defaults(),
})
------------------Bottles---------------------
minetest.register_node("porcelain:glaze_blue", {
	description = "Blue Glaze",
	drawtype = "plantlike",
	tiles = {"blue_glass_bottle.png"},
	inventory_image = "blue_glass_bottle_inventory.png",
	wield_image = "blue_glass_bottle.png",
	use_texture_alpha = true,
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_cyan", {
	description = "Cyan Glaze",
	drawtype = "plantlike",
	tiles = {"cyan_glass_bottle.png"},
	inventory_image = "cyan_glass_bottle_inventory.png",
	wield_image = "cyan_glass_bottle.png",
	use_texture_alpha = true,
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_orange", {
	description = "Orange Glaze",
	drawtype = "plantlike",
	use_texture_alpha = true,
	tiles = {"orange_glass_bottle.png"},
	inventory_image = "orange_glass_bottle_inventory.png",
	wield_image = "orange_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_green", {
	description = "Green Glaze",
	drawtype = "plantlike",
	use_texture_alpha = true,
	tiles = {"green_glass_bottle.png"},
	inventory_image = "green_glass_bottle_inventory.png",
	wield_image = "green_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_yellow", {
	description = "Yellow Glaze",
	drawtype = "plantlike",
	use_texture_alpha = true,
	tiles = {"yellow_glass_bottle.png"},
	inventory_image = "yellow_glass_bottle_inventory.png",
	wield_image = "yellow_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_red", {
	description = "Red Glaze",
	drawtype = "plantlike",
	use_texture_alpha = true,
	tiles = {"red_glass_bottle.png"},
	inventory_image = "red_glass_bottle_inventory.png",
	wield_image = "red_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
minetest.register_node("porcelain:glaze_brown", {
	description = "Brown Glaze",
	drawtype = "plantlike",
	use_texture_alpha = true,
	tiles = {"brown_glass_bottle.png"},
	inventory_image = "brown_glass_bottle_inventory.png",
	wield_image = "brown_glass_bottle.png",
	paramtype = "light",
	is_ground_content = false,
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.25, -0.5, -0.25, 0.25, 0.4, 0.25}
	},
	groups = {vessel=1,dig_immediate=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})
------------------Glaze -------------------
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_blue", 
	recipe = {"refinement:bottle_seed_oil", "dye:blue", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_cyan", 
	recipe = {"refinement:bottle_seed_oil", "dye:cyan", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_orange", 
	recipe = {"refinement:bottle_seed_oil", "dye:orange", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_green", 
	recipe = {"refinement:bottle_seed_oil", "dye:green", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_yellow", 
	recipe = {"refinement:bottle_seed_oil", "dye:yellow", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_red", 
	recipe = {"refinement:bottle_seed_oil", "dye:red", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:glaze_brown", 
	recipe = {"refinement:bottle_seed_oil", "dye:brown", "vessels:glass_bottle"},
	replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})
------------------Sstained stone -------------------
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:cyan_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_cyan"},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:blue_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_blue"},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:orange_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_orange"},
})
minetest.register_craft({
	type = "shapeless",
	output = "porcelain:green_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_green"},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:yellow_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_yellow"},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:red_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_red"},
})
	minetest.register_craft({
	type = "shapeless",
	output = "porcelain:brown_stained_stone", 
	recipe = {"default:stone", "porcelain:glaze_brown"},
})
-------------------cooking--------------------

minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:blue_stained_stone", 
	output = "porcelain:blue_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:cyan_stained_stone", 
	output = "porcelain:cyan_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:orange_stained_stone", 
	output = "porcelain:orange_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:green_stained_stone", 
	output = "porcelain:green_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:yellow_stained_stone", 
	output = "porcelain:yellow_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:red_stained_stone", 
	output = "porcelain:red_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "porcelain:brown_stained_stone", 
	output = "porcelain:brown_porcelain"
})
minetest.register_craft({
	type = "cooking",
	cooktime = 15,
	recipe = "moreblocks:iron_stone", 
	output = "porcelain:white_porcelain"
})