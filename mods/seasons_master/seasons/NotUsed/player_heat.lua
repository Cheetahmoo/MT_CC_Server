local players = {}
local player_positions = {}

hb.register_hudbar("temp", 0xFFFFFF, "", { bar = "hudbars_bar_health.png"}, 20, 20, false)

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	local pos = player:getpos()

	players[player_name] = {
		playerTime = 0
	}
	hb.init_hudbar(player, "temp", nil, nil, true)
end)
minetest.register_on_newplayer(function(player)	
	local player_name = player:get_player_name()
	seasons.savePlayerHeat(player_name, 20)
end)
minetest.register_on_leaveplayer(function(player)
	local player_name = player:get_player_name()
	players[player_name] = nil
end)

minetest.register_on_dieplayer(function(player)
	local player_name = player:get_player_name()
	seasons.savePlayerHeat(player_name, 20)
	hb.change_hudbar(player, "temp", 20)
end)
local winter = true
time = 0
minetest.register_globalstep(function(dtime)
	if winter == true then
		time = time + dtime

		-- every 1 second
		if time < 1 then
			return
		end
		-- reset time for next check
		for player_name,playerInfo in pairs(players) do
			local player = minetest.get_player_by_name(player_name)	
			local playerPos = player:get_pos()
			local player_temp = seasons.get_playerTemp(player:get_player_name())
			players[player_name].playerTime =  players[player_name].playerTime + time

			if seasons.season == "winter" then
				hb.unhide_hudbar(player, "temp")
				
				local armorProtection = seasons.get_play_armor(player) * 0.75
				
				local inside = seasons.isPlayerInWarmAir(player:getpos())
				
				if player_temp < 20 and inside == true then
					
				    players[player_name].playerTime = 0
					player_temp = player_temp + 2
					if player_temp > 20 then
						player_temp = 20
					end
				elseif player:getpos().y >= -15 and inside == false and player_temp >= 1 then
					local standingNode = minetest.get_node(playerPos)
					local groupCooling = minetest.get_item_group(standingNode.name, "Coolplayer")
					if groupCooling >=1 then
						player_temp = player_temp - groupCooling
						players[player_name].playerTime = 0
					elseif players[player_name].playerTime > 5 + armorProtection then
						player_temp = player_temp - 1
						players[player_name].playerTime = 0
					end
				end
				if player_temp <= 0 and inside == false then
					--player:set_hp(player:get_hp()-2)
					if(player:get_hp() <= 0) then
						player_temp = 20
					end
				end
				--UpDates HUD
				hb.change_hudbar(player, "temp", player_temp)
		
				--saves Player Heat
				seasons.savePlayerHeat(player_name, player_temp)
			else
				seasons.savePlayerHeat(player_name, 20)
				hb.change_hudbar(player, "temp", player_temp, 20)
				hb.hide_hudbar(player, "temp")
				
				winter = false
			end
			
		end
		time = 0
	elseif seasons.season == "winter" then
		winter = true

	end
end)

minetest.register_chatcommand("getCover", {
	params = "<action>",
	description = "Season (? = what season, time for time left to season)",
	func = function(name, param)
		player = minetest.env:get_player_by_name(name)
		radius = 6
		minetest.chat_send_player(name, seasons.InShelter(player:getpos(), radius))

	end,
})