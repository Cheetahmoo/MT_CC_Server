----------------------------------------------------------------------------
--                            SETTINGS
----------------------------------------------------------------------------
--Time it takes for Dry Seed Paste to rot
local rot_max = 600
local rot_min = 400


----------------------------------------------------------------------------
--                      NODE REGISTRATIONS
----------------------------------------------------------------------------
--Blighted Dry Seed Paste
crop_blight.register_blighted_node("oil_separation:seed_paste_dry_blighted", {
	description = "Blighted Dry Seed Paste",
    drop = "oil_separation:seed_paste_dry",
    tiles = {"oil_separation_seed_paste_dry.png^oil_separation_blight.png"},
    groups = {crumbly = 3, falling_node = 1, not_in_creative_inventory = 1, flammable = 1, scatters_blight = 1},
    sounds = default.node_sound_sand_defaults(),
    crop_blight_settings = {
        scatter_on_dig = true,
        contaminates_player = true,
    }
})


----------------------------------------------------------------------------
--                         NODE OVERRIDEs
----------------------------------------------------------------------------
--OVERRIDE SEED PASTE DRY--
minetest.override_item("oil_separation:seed_paste_dry", {
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(rot_min,rot_max))
    end,
    on_timer = function(pos)
        minetest.set_node(pos,{name = "oil_separation:seed_paste_dry_blighted"})
    end
}) 