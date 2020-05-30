minetest.register_node("lantern:lantern", {
	tiles = {
		"TOP.png",
		"TOP.png",
		"SIDE.png",
		"SIDE.png",
		"SIDE.png",
		"SIDE.png"
	},
	description = "Lantern",
	light_source = default.LIGHT_MAX-1,
	drawtype = "nodebox",
	paramtype = "light",
	inventory_image = "Inventory.png",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.25, -0.5, -0.25, 0.25, 0.125, 0.25}, -- NodeBox1
			{-0.3125, 0.125, -0.3125, 0.3125, 0.1875, 0.3125}, -- NodeBox2
			{-0.3125, -0.5, -0.3125, 0.3125, -0.4375, 0.3125}, -- NodeBox3
			{-0.25, 0.1875, -0.25, 0.25, 0.25, 0.25}, -- NodeBox4
			{-0.1875, 0.25, -0.1875, 0.1875, 0.3125, 0.1875}, -- NodeBox5
			{-0.0625, 0.25, -0.0625, 0.0625, 0.5, 0.0625}, -- NodeBox6
		}
	},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1},
})
minetest.register_craft({
	output = 'lantern:lantern',
	recipe = {
		{'default:copper_ingot','default:torch',       'default:copper_ingot'},		
		{'default:glass',       'oil_separation:seed_oil_block','default:glass'},
		{'default:copper_ingot','oil_separation:seed_oil_block','default:copper_ingot'},
	},
	--replacements = {{"refinement:bottle_seed_oil", "vessels:steel_bottle"}},
})	