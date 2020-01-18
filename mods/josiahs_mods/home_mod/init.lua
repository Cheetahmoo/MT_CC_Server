minetest.register_node("home_mod:mortar_cobble", {
	tiles = {"morter_cobble.png"},
	description = "Mortar Cobble",
	inventory_image = minetest.inventorycube("morter_cobble.png"),
	groups = {cracky = 3, stone = 1},
	drops = "",
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("home_mod:dad_block", {
	tiles = {"dad_block.png","dad_block.png","dad_block.png","dad_block2.png","dad_block.png","dad_block3.png"},
	description = "dad block",
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block2.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("home_mod:dad_block5", {
	tiles = {"dad_block5.png"},
	description = "dad block5",
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block5.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("home_mod:dad_block2", {
	tiles = {"dad_block.png","dad_block.png","dad_block2.png","dad_block.png","dad_block3.png","dad_block.png"},
	description = "dad block2",
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block2.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults()	
}) 
minetest.register_node("home_mod:dad_block3", {
	tiles = {"dad_block.png","dad_block.png","dad_block3.png","dad_block.png","dad_block.png","dad_block2.png"},
	description = "dad block3",
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block2.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),	
})
minetest.register_node("home_mod:dad_block4", {
	tiles = {"dad_block.png","dad_block.png","dad_block.png","dad_block3.png","dad_block2.png","dad_block.png"},
	description = "dad block4",
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block2.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_node("home_mod:dad_block5", {
	tiles = {"dad_block.png"},
	description = "dad block5";
	drawtype = "node_box",
	paramtype = "light",
	inventory_image = minetest.inventorycube("dad_block.png"),
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})            
--water fall glass
minetest.register_node("home_mod:water_fall" , {
	description = "water fall",
	drawtype = "nodebox",
	tiles = {
		{
			name = "water_fall.png",
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2.0,
			},
		},
	},
	walkable = false,
	inventory_image = ("water_fall_in.png"),
 	paramtype = "light",
	paramtype2 = "wallmounted",
    sunlight_propagates = true,
    is_ground_content = true,
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	sounds = default.node_sound_glass_defaults(),
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.5, 0.4375, -0.5, 0.5, 0.5, 0.5},
		wall_bottom = {-0.5, -0.5, -0.5, 0.5, -0.4375, 0.5},
		wall_side   = {-0.5, -0.5, -0.5, -0.4375, 0.5, 0.5},
	},
})	
	
minetest.register_craft({
	output = 'home_mod:water_fall 8',
	recipe = {
		{'default:glass','bucket:bucket_water','default:glass'},
		{'default:glass','default:steel_ingot','default:glass'},	
	}	
})

--Lead Glass
minetest.register_node("home_mod:glass_clean_lead_pane" , {
	description = "Lead Glass",
	drawtype = "nodebox",
	tiles = {"glass_cleen_lead_pane_nothing_front.png","glass_cleen_lead_pane_nothing_front.png" ,"glass_cleen_lead_pane_front.png" ,"glass_cleen_lead_pane_front.png" ,"glass_cleen_lead_pane_front.png" ,"glass_cleen_lead_pane_front.png" ,"glass_cleen_lead_pane_nothing_front.png" },
	walkable = true,
	inventory_image = ("glass_cleen_lead_pane_borders_front.png"),
	paramtype = "light",
	paramtype2 = "facedir",
    sunlight_propagates = true,
	is_ground_content = true,
	groups = {snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
	sounds = default.node_sound_glass_defaults(),
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
})		
minetest.register_craft({
	output = 'home_mod:glass_clean_lead_pane',
	recipe = {
		{'default:glass','default:obsidian_shard',''},	
	}
})