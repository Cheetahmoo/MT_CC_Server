
local v = "group:wool"
armor:register_armor("seasons:helmet_wool", {
    description = "wool Helmet",
    inventory_image = "seasons_inv_helmet_wool.png",
    groups = {armor_head=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=5},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
    texture = "seasons_helmet_wool.png"
})
armor:register_armor("seasons:chestplate_wool", {
    description = "wool Chestplate",
    inventory_image = "seasons_inv_chestplate_wool.png",
    groups = {armor_torso=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
    texture = "seasons_chestplate_wool.png"
})
armor:register_armor("seasons:leggings_wool", {
    description = "wool Leggings",
    inventory_image = "seasons_inv_leggings_wool.png",
    groups = {armor_legs=1, armor_heal=0, armor_use=2000, flammable=1},
    armor_groups = {fleshy=10},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
    texture = "seasons_leggings_wool.png"
})
armor:register_armor("seasons:boots_wool", {
    description = "wool Boots",
    inventory_image = "seasons_inv_boots_wool.png",
    armor_groups = {fleshy=5},
    damage_groups = {cracky=3, snappy=2, choppy=3, crumbly=2, level=1},
    groups = {armor_feet=1, armor_heal=0, armor_use=2000, flammable=1},
    texture = "seasons_boots_wool.png"
})
minetest.register_craft({
    output = "seasons:helmet_wool",
    recipe = {
        {v, v, v},
        {v, "", v},
        {"", "", ""},
    },
})
minetest.register_craft({
    output = "seasons:chestplate_wool",
    recipe = {
        {v, "", v},
        {v, v, v},
        {v, v, v},
    },
})
minetest.register_craft({
    output = "seasons:leggings_wool",
    recipe = {
        {v, v, v},
        {v, "", v},
        {v, "", v},
    },
})
minetest.register_craft({
    output = "seasons:boots_wool",
    recipe = {
        {v, "", v},
        {v, "", v},
    },
})