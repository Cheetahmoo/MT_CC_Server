----------------------------------------------------------------------------
--                   OIL SEPARATION MOD INIT
----------------------------------------------------------------------------
oil_separation = {} --Establish "oil_separation" name space


----------------------------------------------------------------------------
--                           SETTINGS
----------------------------------------------------------------------------
--To change settings for the stains or the blight, see the respective scripts

--The "separation_time" variable controls how long before oil separates from paste.
--Used in two places in the "seed_paste_oily" node registration.
oil_separation.separation_time = 50 --Default (50)

--Chance that oily paste will not dry out after releasing oil near fire. Read as "1 out of fire_chance"
oil_separation.fire_chance = 2

--Chance that lava or ice will be 'used-up' after affecting paste/oil. Read as "1 out of energy_loss_chance"
oil_separation.energy_loss_chance = 20


----------------------------------------------------------------------------
--                           LOAD FILES
----------------------------------------------------------------------------
oil_separation.path = minetest.get_modpath("oil_separation")

dofile(oil_separation.path .. "/farming_changes.lua")
dofile(oil_separation.path .. "/nodes.lua")
dofile(oil_separation.path .. "/abm.lua")
if minetest.get_modpath("crop_blight") then
    dofile(oil_separation.path .. "/blight.lua") --Comment out this line to remove blight
end