-------------------------------------------------------------------
--                  NODE REGISTRATION
-------------------------------------------------------------------
local normal_nodes = {
	["western_stone"] = {
		description = "Western Stone",
		tiles = {"mt_cc_nodes_western_stone.png"},
		groups = {cracky = 3, stone = 1},
		sounds = default.node_sound_stone_defaults(),
		--craft
		recipe_type = "cooking",
		recipe_recipe = "default:desert_stone",
	},

	["western_stone_block"] = {
		description = "Western Stone Block",
		tiles = {"mt_cc_nodes_western_stone_block.png"},
		groups = {cracky = 3, stone = 1},
		sounds = default.node_sound_stone_defaults(),
		--craft
		recipe_type = nil,
		recipe_recipe = {
			{"mt_cc_nodes:western_stone","mt_cc_nodes:western_stone"},
			{"mt_cc_nodes:western_stone","mt_cc_nodes:western_stone"},
		},
	},

	["eastern_stone"] = {
		description = "Eastern Stone",
		tiles = {"mt_cc_nodes_eastern_stone.png"},
		groups = {cracky = 3, stone = 1},
		sounds = default.node_sound_stone_defaults(),
		--craft
		recipe_type = "cooking",
		recipe_recipe = "default:desert_stone",
	},

	["eastern_stone_block"] = {
		description = "Eastern Stone Block",
		tiles = {"mt_cc_nodes_eastern_stone_block.png"},
		groups = {cracky = 3, stone = 1},
		sounds = default.node_sound_stone_defaults(),
		--craft
		recipe_type = nil,
		recipe_recipe = {
			{"mt_cc_nodes:eastern_stone","mt_cc_nodes:eastern_stone"},
			{"mt_cc_nodes:eastern_stone","mt_cc_nodes:eastern_stone"},
		},
	},

	["bark_ball"] = {
		description = "Bark Ball",
		tiles = {"default_tree.png"},
		paramtype2 = "facedir",
		groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		crop_blight_settings = {
			infectable_settings = {
				infected_version = "crop_blight:tree_blighted",
				chance = 1,
			},
		},
		--craft
		recipe_type = nil,
		recipe_recipe = {
			{"default:tree", "default:tree"},
			{"default:tree", "default:tree"},
		},
		recipe_output = "mt_cc_nodes:bark_ball 4",
	},

	["bark_ball_pine"] = {
		description = "Pine Bark Ball",
		tiles = {"default_pine_tree.png"},
		paramtype2 = "facedir",
		groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		crop_blight_settings = {
			infectable_settings = {
				infected_version = "crop_blight:pine_tree_blighted",
				chance = 1,
			},
		},
		--craft
		recipe_type = nil,
		recipe_recipe = {
			{"default:pine_tree", "default:pine_tree"},
			{"default:pine_tree", "default:pine_tree"},
		},
		recipe_output = "mt_cc_nodes:pine_bark_ball 4",
	},

	["bark_ball_jungle"] = {
		description = "Jungle Bark Ball",
		tiles = {"default_jungletree.png"},
		paramtype2 = "facedir",
		groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
		sounds = default.node_sound_wood_defaults(),
		--craft
		recipe_type = nil,
		recipe_recipe = {
			{"default:jungletree", "default:jungletree"},
			{"default:jungletree", "default:jungletree"},
		},
		recipe_output = "mt_cc_nodes:jungle_bark_ball 4"
	},
}



for name, def in pairs(normal_nodes) do

	--Register Nodes
	minetest.register_node("mt_cc_nodes:"..name, {
		description = def.description,
		tiles = def.tiles,
		paramtype2 = def.paramtype2 or nil,
        groups = def.groups or nil,
		sounds = def.sounds or nil,
		crop_blight_settings = def.crop_blight_settings or nil,
	})

	--Make cuttable
	if minetest.get_modpath("moreblocks") then
        stairsplus:register_all("mt_cc_nodes", name, "mt_cc_nodes:"..name, {
            description = def.description,
			tiles = def.tiles,
            groups = table.copy(def.groups),
            sounds = def.sounds,
            sunlight_propagates = true,
        })
	end

	--Create recipies
	minetest.register_craft({
		type = def.recipe_type,
		output = def.recipe_output or "mt_cc_nodes:"..name,
		recipe = def.recipe_recipe,
	})
end

--MESE CRYSTALS--
minetest.register_craftitem("mt_cc_nodes:compresed_mese_fragment",{
	description = "Compresed Mese Fragment",
	inventory_image = ("mt_cc_nodes_compresed_mese_fragment.png"),
})

minetest.register_craft({
	output = "mt_cc_nodes:compresed_mese_fragment",
	recipe = {
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
		{"default:mese_crystal_fragment", "default:mese_crystal_fragment", "default:mese_crystal_fragment"},
	}
})

minetest.register_craft({
	output = 'default:mese_crystal',
	recipe = {
		{"mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment"},
		{"mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment"},
		{"mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment", "mt_cc_nodes:compresed_mese_fragment"},
	}
})

minetest.register_craft({
	output = "mt_cc_nodes:compresed_mese_fragment 9",
	recipe = {
		{'default:mese_crystal'},
	}
})

minetest.register_craft({
	output = "default:mese_crystal_fragment 9",
	recipe = {
		{"mt_cc_nodes:compresed_mese_fragment"},
	}
})