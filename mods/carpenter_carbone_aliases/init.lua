--This mod registers all aliases needed for carpenter Carbone

--Parts of Cut Blocks Names
--form: "modname:"..name_parts[i][1].."node name"..name_parts[i][2]
local cut_name_parts = {
    {"panel_", "_1"},
    {"slab_", ""},
    {"micro_", "_14"},
    {"slope_", ""},
    {"micro_", "_1"},
    {"stair_", ""},
    {"panel_", "_12"},
    {"slope_", "_outer_half_raised"},
    {"panel_", "_14"},
    {"slope_", "_outer_cut"},
    {"micro_", "_4"},
    {"slab_", "_2"},
    {"slab_", "_14"},
    {"micro_", ""},
    {"panel_", "_2"},
    {"stair_", "_right_half"},
    {"stair_", "_inner"},
    {"micro_", "_15"},
    {"slab_", "_1"},
    {"slab_", "_three_quarter"},
    {"stair_", "_half"},
    {"panel_", ""},
    {"stair_", "_alt_4"},
    {"panel_", "_15"},
    {"slab_", "_quarter"},
    {"stair_", "_outer"},
    {"slope_", "_outer_half"},
    {"slope_", "_inner_cut_half_raised"},
    {"slope_", "_outer_cut_half_raised"},
    {"stair_", "_alt_1"},
    {"stair_", "_alt_2"},
    {"stair_", "_alt"},
    {"slope_", "_outer"},
    {"slope_", "_inner"},
    {"slope_", "_cut"},
    {"slope_", "_inner_cut"},
    {"slope_", "_inner_half"},
    {"slope_", "_outer_cut_half"},
    {"slope_", "_half"},
    {"slope_", "_half_raised"},
    {"slope_", "_inner_half_raised"},
    {"micro_", "_2"},
    {"slab_", "_15"},
    {"micro_", "_12"},
    {"slope_", "_inner_cut_half"},
    {"panel_", "_4"},
}

---------------------------------------------------------------------------------
--                               PLASTERS
---------------------------------------------------------------------------------
local plaster_mod_name_old = "plasters"
local plaster_mod_name_new = "plaster"

local plaster_node_name_key = {
    {"plaster_raw", "plaster_white"},
    {"plaster_pink", "plaster_red"},
    {"plaster_red", "plaster_dark_red"},
    {"plaster_brown", "plaster_brown"},
    {"plaster_orange", "plaster_dark_orange"},
    {"plaster_yellow", "plaster_yellow"},
    {"plaster_green", "plaster_avocado"},
    {"plaster_dark_green", "plaster_dark_avocado"},
    {"plaster_cyan", "plaster_cyan"},
    {"plaster_blue", "plaster_blue"},
    {"plaster_violet", "plaster_violet"},
    {"plaster_magenta", "plaster_red"},
    {"plaster_black", "plaster_black"},
    {"plaster_dark_grey", "plaster_grey"},
}

--Register Aliases for Plaster Nodes
for i, key in ipairs(plaster_node_name_key) do
    local old = plaster_mod_name_old..":"..key[1]
    local new = plaster_mod_name_new..":"..key[2]
    minetest.register_alias(old, new)
end

--Register Aliases for Cut Plaster
for i, key in ipairs(plaster_node_name_key) do
    for j, part in ipairs(cut_name_parts) do
        local old = "moreblocks:"..part[1]..key[1]..part[2]
        local new = "plaster:"..part[1]..key[2]..part[2]
        minetest.register_alias(old, new)
    end
end

--Register MISC Aliases
minetest.register_alias("home_mod:mortar", "plaster:mortar")

---------------------------------------------------------------------------------
--                               PORCELAIN
---------------------------------------------------------------------------------
local porcelain_mod_name_old = "porcelain"
local porcelain_mod_name_new = "porcelain"

local porcelain_node_name_key = {
    {"red_porcelain", "porcelain_red"},
    {"black_porcelain", "porcelain_black"},
    {"white_porcelain", "porcelain_white"},
    {"blue_porcelain", "porcelain_blue"},
    {"yellow_porcelain", "porcelain_yellow"},
    {"brown_porcelain", "porcelain_brown"},
    {"orange_porcelain", "porcelain_orange"},
    {"green_porcelain", "porcelain_green"},
}

--Register Aliases for Porcelain Nodes
for i, key in ipairs(porcelain_node_name_key) do
    local old = porcelain_mod_name_old..":"..key[1]
    local new = porcelain_mod_name_new..":"..key[2]
    minetest.register_alias(old, new)
end

--Register Aliases for Cut Porcelain
for i, key in ipairs(porcelain_node_name_key) do
    for j, part in ipairs(cut_name_parts) do
        local old = "moreblocks:"..part[1]..key[1]..part[2]
        local new = "porcelain:"..part[1]..key[2]..part[2]
        minetest.register_alias(old, new)
    end
end

--Register MISC Aliases
minetest.register_alias("porcelain:cyan_porcelain", "plaster:plaster_blue")
for j, part in ipairs(cut_name_parts) do
    local old = "moreblocks:"..part[1].."cyan_porcelain"..part[2]
    local new = "plaster:"..part[1].."plaster_blue"..part[2]
    minetest.register_alias(old, new)
end

---------------------------------------------------------------------------------
--                             MORE ALIASES
---------------------------------------------------------------------------------
minetest.register_alias("moreblocks:stair_pinewood","moreblocks:stair_pine_wood")
minetest.register_alias("carts:rail_copper", "carts:rail")