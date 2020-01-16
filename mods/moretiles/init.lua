-- Minetest 0.4 mod: music Block
minetest.register_node("moretiles:western_stone" , {
	description = "Western Stone",
	tiles = {"western_stone.png"},
	groups = {cracky = 3, stone = 1},
	diggable = true,
	sounds = default.node_sound_stone_defaults()
			
})
minetest.register_craft({
	type = "cooking",
	recipe = "default:desert_stone",
	output = 'moretiles:western_stone',
})
minetest.register_node("moretiles:western_stone_block", {
	description = "Western Stone Block",
	tiles = {"western_stone_block.png"},
	groups = {cracky = 3, stone = 1},
	diggable = true,
	sounds = default.node_sound_stone_defaults()
})
minetest.register_craft({
	output = 'moretiles:western_stone_block 4',
	recipe = {
		{'','',''},
		{'','moretiles:western_stone','moretiles:western_stone'},
		{'','moretiles:western_stone','moretiles:western_stone'},
	}
})

-- EASTERN STONE REGISTRY

minetest.register_node("moretiles:eastern_stone" , {
	description = "Eastern Stone",
	tiles = {"eastern_stone.png"},
	groups = {cracky = 3, stone = 1},
	diggable = true,
	sounds = default.node_sound_stone_defaults()
			
})
minetest.register_craft({
	type = "cooking",
	recipe = "default:stone",
	output = 'moretiles:eastern_stone',
})
minetest.register_node("moretiles:eastern_stone_block", {
	description = "Eastern Stone Block",
	tiles = {"eastern_stone_block.png"},
	groups = {cracky = 3, stone = 1},
	diggable = true,
	sounds = default.node_sound_stone_defaults()
})
minetest.register_craft({
	output = 'moretiles:eastern_stone_block 4',
	recipe = {
		{'','',''},
		{'','moretiles:eastern_stone','moretiles:eastern_stone'},
		{'','moretiles:eastern_stone','moretiles:eastern_stone'},
	}
})