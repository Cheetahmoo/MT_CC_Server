This Mod is for Carpenter Carbone
------------------SetUp----------
if Hunger mod is instaled add this code the the start of the food.lua
if minetest.get_modpath("weather") ~= nil then
		register_food("weather:apple_roten", 1, "", 12)