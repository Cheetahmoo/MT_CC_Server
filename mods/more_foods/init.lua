------Foods------

minetest.register_craftitem("more_foods:soup_bowl", {
	description = "Soup Bowl",
	inventory_image = "soup_bowl_empty.png",
	groups = {bowl=1},
})

minetest.register_craftitem("more_foods:soup_mushroom_brown", {
	description = "Bowl Of Brown Mushroom Soup",
    inventory_image = "soup_bowl_brown_mushroom.png",
    on_use = minetest.item_eat(4),
	groups = {soup=1, bowl=1},
})
minetest.register_craftitem("more_foods:soup_mushroom_mix", {
	description = "Bowl Of Mushroom Mix Soup",
    inventory_image = "soup_bowl_mix_mushroom.png",
    on_use = minetest.item_eat(4),
	groups = {soup=1, bowl=1},
})
minetest.register_craftitem("more_foods:soup_mushroom_mix_poison", {
	description = "Bowl Of Hardy Soup",
    inventory_image = "soup_bowl_mix_mushroom.png",
    on_use = minetest.item_eat(-4),
	groups = {soup=1, bowl=1, not_in_creative_inventory = 1},
})

------Crafting-------
minetest.register_craft({
	output = "more_foods:soup_bowl 3",
	recipe = {
        {"group:wood", "", "group:wood"},
        {"", "group:wood", ""},
	}
})
minetest.register_craft({
    output = "more_foods:soup_mushroom_mix",
    type = "shapeless",
	recipe = {"flowers:mushroom_red_", "flowers:mushroom_brown","flowers:mushroom_brown","flowers:mushroom_brown", "more_foods:soup_bowl"},
})
minetest.register_craft({
    output = "more_foods:soup_mushroom_mix_poison",
    type = "shapeless",
	recipe = {"flowers:mushroom_red", "flowers:mushroom_brown","flowers:mushroom_brown","flowers:mushroom_brown", "more_foods:soup_bowl"},
})
minetest.register_craft({
    output = "more_foods:soup_mushroom_brown",
    type = "shapeless",
	recipe = {"flowers:mushroom_brown", "flowers:mushroom_brown","flowers:mushroom_brown","flowers:mushroom_brown", "more_foods:soup_bowl"},
})

-------Register Food-------
hunger.register_food("more_foods:soup_mushroom_mix", 4, "more_foods:soup_bowl 1", nil, 3)

hunger.register_food("more_foods:soup_mushroom_mix_poison", 1, "more_foods:soup_bowl 1", 5)

hunger.register_food("more_foods:soup_mushroom_brown", 4, "more_foods:soup_bowl 1")