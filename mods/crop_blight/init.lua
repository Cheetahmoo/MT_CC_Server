----------------------------------------------------------------------------
--                   CROP BLIGHT MOD INIT
----------------------------------------------------------------------------
crop_blight = {} --Establish "crop_blight" name space


----------------------------------------------------------------------------
--                          SETTINGS
----------------------------------------------------------------------------
--How often to check if player is near a contamination node
crop_blight.check_interval = 4

--Time a player will be infected after contact with a contaminating node
crop_blight.player_blighted_time = 50

--How often a player scatters blight while infected
crop_blight.player_scatter_interval = 8

--Distance around a player which might be reached by blight when player is infected
crop_blight.scatter_dist_max = 8 
crop_blight.scatter_dist_min = 3

--Time it takes for an infected node to infect its neighbor
crop_blight.spread_time_max = 20
crop_blight.spread_time_min = 8


----------------------------------------------------------------------------
--                           LOAD FILES
----------------------------------------------------------------------------
crop_blight.path = minetest.get_modpath("crop_blight")

dofile(crop_blight.path .. "/functions.lua")
dofile(crop_blight.path .. "/nodes.lua")
dofile(crop_blight.path .. "/overrides.lua")