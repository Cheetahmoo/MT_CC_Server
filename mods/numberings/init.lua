
minetest.register_node("numberings:zero", {
	description = "Two",
	tiles = {"0.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"0.png"},
	inventory_image = "0.png",
	wield_image = "0.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})
minetest.register_craft({
	output = 'numberings:zero',
		recipe = {
		
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', '', 'group:wood'},
		{'group:wood', 'dye:black', 'group:wood'},
		
		}
})

minetest.register_node("numberings:one", {
	description = "One",
	tiles = {"1.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"1.png"},
	inventory_image = "1.png",
	wield_image = "1.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:one',
		recipe = {
		
		{'dye:black', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}
})
minetest.register_node("numberings:two", {
	description = "Two",
	tiles = {"2.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"2.png"},
	inventory_image = "2.png",
	wield_image = "2.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:two',
		recipe = {
		
		{'group:wood', 'dye:black', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}

})
minetest.register_node("numberings:three", {
	description = "Three",
	tiles = {"3.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"3.png"},
	inventory_image = "3.png",
	wield_image = "3.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:three',
		recipe = {
		
		{ 'group:wood', 'group:wood', 'dye:black'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}

})minetest.register_node("numberings:four", {
	description = "four",
	tiles = {"4.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"4.png"},
	inventory_image = "4.png",
	wield_image = "4.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:four',
		recipe = {
		
		{ 'group:wood', 'group:wood', 'group:wood'},
		{'dye:black','group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}

})minetest.register_node("numberings:five", {
	description = "Five",
	tiles = {"5.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"5.png"},
	inventory_image = "5.png",
	wield_image = "5.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:five',
		recipe = {
		
		{'group:wood', 'group:wood', 'group:wood'},
		{ 'group:wood', 'dye:black','group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}

})minetest.register_node("numberings:six", {
	description = "Six",
	tiles = {"6.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"6.png"},
	inventory_image = "6.png",
	wield_image = "6.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:six',
		recipe = {
		
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'dye:black'},
		{'group:wood', 'group:wood', 'group:wood'},
		
		}

})
minetest.register_node("numberings:seven", {
	description = "Seven",
	tiles = {"7.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"7.png"},
	inventory_image = "7.png",
	wield_image = "7.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:seven',
		recipe = {
		
		{'group:wood','group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'dye:black', 'group:wood', 'group:wood'},
		
		}

})minetest.register_node("numberings:eight", {
	description = "Eight",
	tiles = {"8.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"8.png"},
	inventory_image = "8.png",
	wield_image = "8.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:eight',
		recipe = {
		
		{ 'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'dye:black','group:wood'},
		
		}

})minetest.register_node("numberings:nine", {
	description = "Nine",
	tiles = {"9.png"},
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"9.png"},
	inventory_image = "9.png",
	wield_image = "9.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	light_source = default.LIGHT_MAX-1,
})

minetest.register_craft({
	output = 'numberings:nine',
		recipe = {
		
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'group:wood'},
		{'group:wood', 'group:wood', 'dye:black'},
		
		}
})