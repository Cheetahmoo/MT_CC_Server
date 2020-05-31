
seasons = {}

--min Hieght that anything is affected by seasons
seasons.minHeight = -20

--Mod Storage
local season_storage = minetest.get_mod_storage()

--Default season To start with
seasons.season = season_storage:get_string("season") or "spring"

--Season time AKA time it takes for each season
seasons.winterTime = minetest.setting_get("season_winter_days") or 360
seasons.springTime = minetest.setting_get("season_spring_days") or 360
seasons.summerTime = minetest.setting_get("season_summer_days") or 360
seasons.fallTime = minetest.setting_get("season_fall_days") or 360



--Keep track of players how many players are on the serve
local playerNumber


--The time in which the last season switched
seasons.lastSeasonTime = tonumber(season_storage:get_string("lastSeasonTime")) or 1

--current time of season
seasons.time = 0

minetest.register_on_joinplayer(function(player)
	if seasons.season == "fall" then
		skybox.set(player, 2)
	end
end)

--Food
hunger.register_food("seasons:apple_roten", 6, "", 12)
hunger.register_food("flowers:mushroom_red_", 1, "", nil, 5)

--
-- Load seasons Database
--

-- Multiply by 60 because day 60 seconds in an minutes

if seasons.season == "spring" then
	seasonsTime = 60 * seasons.springTime
elseif seasons.season == "summer" then
	seasonsTime = 60 * seasons.summerTime
elseif seasons.season == "fall" then
	seasonsTime = 60 * seasons.fallTime
elseif seasons.season == "winter" then
	seasonsTime = 60 * seasons.winterTime
else
	seasons.season = "spring"
	seasonsTime = 60 * seasons.springTime
end

--
-- Load Files
--
--dofile(minetest.get_modpath("seasons").."/nodes.lua")
dofile(minetest.get_modpath("seasons").."/particles.lua")
dofile(minetest.get_modpath("seasons").."/functions.lua")
--dofile(minetest.get_modpath("seasons").."/abm.lua")
dofile(minetest.get_modpath("seasons").."/new_season_handler.lua")
--
-- Season Controler
--


local function SaveseasonsData(_lastseasonsTime, _season)	
	season_storage:set_string("season", _season)
	season_storage:set_string("lastSeasonTime", _lastseasonsTime)
end

function seasons.savePlayerHeat(_player_name, _tempValue)
	season_storage:set_int(_player_name .. " temp", _tempValue)
end

function seasons.get_playerTemp(_player_name)
	local  temp = season_storage:get_int(_player_name .." temp")
	if temp == nil then
		temp = 10
	end
	return temp
end

minetest.register_on_shutdown(function()
	SaveseasonsData(seasons.lastSeasonTime, tostring(seasons.season))
end)

local function NextSeason()
	if seasons.season == "spring" then
		seasonsTime = 60 * seasons.springTime
		seasons.season = "summer"
	elseif seasons.season == "summer" then
		seasonsTime = 60 * seasons.summerTime
		seasons.season = "fall"
	elseif seasons.season == "fall" then
		seasonsTime = 60 * seasons.fallTime
		seasons.season = "winter"
	elseif seasons.season == "winter" then
		seasons.season = "spring"
		seasonsTime = 60 * seasons.winterTime
	else
		seasons.season = "spring"
		seasonsTime = 60 * seasons.springTime
	end
	SaveseasonsData(lastseasonsTime, tostring(seasons.season))
	minetest.request_shutdown("Seasons are Switching to ".. seasons.season, core.is_yes(true), 0)
end
local timer = 60
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer < 5 then
		return
	end
	timer = 0
	if #minetest.get_connected_players() <1 then
		seasons.lastSeasonTime = seasons.lastSeasonTime + 5
		return
	end
	
	if seasons.time >= seasonsTime then
		seasons.lastSeasonTime = minetest.get_gametime()
		seasons.time = 0
		NextSeason()
		return
	end

	seasons.time = minetest.get_gametime() - seasons.lastSeasonTime
	--minetest.chat_send_all(seasons.season .. " has " .. math.floor((seasons.fallTime-(seasons.time/60))+0.5) .. " minutes Left.")
	
end)

--
-- Chat Commands
--

minetest.register_chatcommand("season", {
	params = "<action>",
	description = "Season (? = what season, summer, fall, winter and spring change the season)",
	privs = {server=true},
	func = function( _, param)		
		if param == nil then
			return false, "Invalid  Input"
		elseif param == "spring" then
			seasons.season = "spring"
			seasons.lastSeasonTime = minetest.get_gametime()
			seasons.time = 0
			minetest.request_shutdown("Admin is Switching Seasons to ".. seasons.season, core.is_yes(true), 0)
			return false, "It's now " .. param
		elseif param == "summer" then
			seasons.season = "summer"
			seasons.lastSeasonTime = minetest.get_gametime()
			seasons.time = 0
			minetest.request_shutdown("Admin is Switching Seasons to ".. seasons.season, core.is_yes(true), 0)
			return false, "It's now " .. param
		elseif param == "fall" then
			seasons.season = "fall"
			seasons.lastSeasonTime = minetest.get_gametime()
			seasons.time = 0
			minetest.request_shutdown("Admin is Switching Seasons to ".. seasons.season, core.is_yes(true), 0)
			return false, "It's now " .. param
		elseif param == "winter" then
			seasons.season = "winter"
			seasons.lastSeasonTime = minetest.get_gametime()
			seasons.time = 0
			minetest.request_shutdown("Admin is Switching Seasons to ".. seasons.season, core.is_yes(true), 0)
			return false, "It's now " .. param
		elseif param == "time" then
			return true, "Seasons time is " .. (lastseasonsTime + seasonsTime) - minetest.get_gametime()
		else
			return false, "Invalid  Input"
		end

	end,
})
minetest.register_chatcommand("season?", {
	params = "<action>",
	description = "Season (? = what season, time for time left to season)",
	func = function( name, param)
		return true, seasons.season .. " has " .. seasons.fallTime-(seasons.time/60) .. " minutes Left."
	end,
})
--
-- Hidding name Tags
--
invisible={time=0,armor=minetest.get_modpath("3d_armor")}
invisible.toogle=function(user,sneak)
	local name=user:get_player_name()
	if not invisible[name] then
		invisible[name]={}
		user:set_nametag_attributes({color = {a = 0, r = 255, g = 255, b = 255}})
	else
		user:set_nametag_attributes({color = {a = 255, r = 255, g = 255, b = 255}})
		invisible[name]=nil
	end
end

minetest.register_globalstep(function(dtime)
	invisible.time=invisible.time+dtime
	if invisible.time<0.5 then return end
	invisible.time=0
	for _, player in pairs(minetest.get_connected_players()) do
		local name=player:get_player_name()
		local sneak=player:get_player_control().sneak
		if (sneak and not invisible[name]) or (sneak==false and invisible[name] and not invisible[name].tool) then
			invisible.toogle(player)
		end
	end
end)