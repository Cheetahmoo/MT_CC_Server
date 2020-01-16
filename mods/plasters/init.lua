
---------------Plasters--------------------------

--sounds
local function node_sound_plaster()
	local table = {}
	table.footstep = {name = "plaster_footstep", gain = 0.3, }
	table.dug = {name = "default_hard_footstep", gain = 1.0}
	table.place = {name = "default_place_node_hard", gain = 1.0}
	--default.node_sound_defaults(table)
	return table
end


------Nodes------------
minetest.register_node("plasters:plaster_raw", {
	description = "Raw Plaster",
	tiles = {"plaster_raw.png"},
	inventory_image = minetest.inventorycube("plaster_raw.png"),	
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})

minetest.register_node("plasters:plaster_green", {
	description = "Green Plaster",
	drawtype = "nodebox",
	tiles = {"plaster_green.png"},
	inventory_image = minetest.inventorycube("plaster_green.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_blue", {
	description = "Blue Plaster",
	tiles = {"plaster_blue.png"},
	inventory_image = minetest.inventorycube("plaster_blue.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_black", {
	description = "Black Plaster",
	tiles = {"plaster_black.png"},
	inventory_image = minetest.inventorycube("plaster_black.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})

minetest.register_node("plasters:plaster_brown", {
	description = "Brown Plaster",
	tiles = {"plaster_brown.png"},
	inventory_image = minetest.inventorycube("plaster_brown.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_cyan", {
	description = "Cyan Plaster",
	tiles = {"plaster_cyan.png"},
	inventory_image = minetest.inventorycube("plaster_cyan.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_dark_green", {
	description = "Dark Green Plaster",
	tiles = {"plaster_dark_green.png"},
	inventory_image = minetest.inventorycube("plaster_dark_green.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_dark_grey", {
	description = "Dark Gray Plaster",
	tiles = {"plaster_dark_grey.png"},
	inventory_image = minetest.inventorycube("plaster_dark_grey.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_magenta", {
	description = "Magenta Plaster",
	tiles = {"plaster_magenta.png"},
	inventory_image = minetest.inventorycube("plaster_magenta.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_orange", {
	description = "Orange Plaster",
	tiles = {"plaster_orange.png"},
	inventory_image = minetest.inventorycube("plaster_orange.png"),	
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_pink", {
	description = "Pink Plaster",
	tiles = {"plaster_pink.png"},
	inventory_image = minetest.inventorycube("plaster_pink.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_red", {
	description = "Red Plaster",
	tiles = {"plaster_red.png"},
	inventory_image = minetest.inventorycube("plaster_red.png"),	
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_violet", {
	description = "Violet Plaster",
	tiles = {"plaster_violet.png"},
	inventory_image = minetest.inventorycube("plaster_violet.png"),
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})
minetest.register_node("plasters:plaster_yellow", {
	description = "Yellow Plaster",
	tiles = {"plaster_yellow.png"},
	inventory_image = minetest.inventorycube("plaster_yellow.png"),	
	groups = {crumbly = 2, cracky = 3, snow_cover = 1},
	sounds = node_sound_plaster(),
})

--
-------------Recipes-----------------
--
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_pink',
	recipe = {'dye:pink', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_green',
	recipe = {'dye:green', 'home_mod:mortar'},		
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_raw',
	recipe = {'dye:white', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_yellow',
	recipe = {'dye:yellow', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_violet',
	recipe = {'dye:violet', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_red',
	recipe = {'dye:red', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_orange',
	recipe = {'dye:orange', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_blue',
	recipe = {'dye:blue', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_black',
	recipe = {'dye:black', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_brown',
	recipe = {'dye:brown', 'home_mod:mortar'},	
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_cyan',
	recipe = {'dye:cyan', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_dark_green',
	recipe = {'dye:dark_green', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_dark_grey',
	recipe = {'dye:dark_grey', 'home_mod:mortar'},
})
minetest.register_craft({
	type = "shapeless",
	output = 'plasters:plaster_magenta',
	recipe = {'dye:magenta', 'home_mod:mortar'},
})