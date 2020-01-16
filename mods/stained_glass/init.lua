minetest.register_node("stained_glass:stained_glass_green", {
	description = "Green Staind Glass",
	drawtype = "glasslike",
	tiles = {"stained_glass_green2.png"},
	use_texture_alpha = true,
	inventory_image = minetest.inventorycube("stained_glass_green2.png"),
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3, oddly_breakable_by_hand = 3},
	sounds = default.node_sound_glass_defaults(),
})	
minetest.register_craft({
	output = 'stained_glass:stained_glass_green',
	recipe = {	
		{'default:glass','dye:dark_green'},
	}
})	
