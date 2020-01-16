playeranim = {}
playeranim.Model = dofile(minetest.get_modpath("playeranim").."/src/model.lua") -- Can be used by external mods

if not minetest.settings:get("playeranim.disable_forcing_60fps") then
	minetest.settings:set("dedicated_server_step", 1 / 60)
end

dofile(minetest.get_modpath("playeranim").."/src/api.lua")
dofile(minetest.get_modpath("playeranim").."/src/mtg_models.lua")
dofile(minetest.get_modpath("playeranim").."/src/animate_player.lua")

local model = minetest.settings:get("playeranim.model_version")
if model == "" or model == nil then
	model = "MTG_4_Nov_2017"
end
playeranim.set_default_player_model(model)
