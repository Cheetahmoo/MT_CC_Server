local runreplacement = minetest.get_mod_storage()


if(runreplacement:get_string("ranReplace") == "") then
	local IceReplacement = "cyan_porcelain"
	minetest.register_on_joinplayer(function(player)
		local player_name = player:get_player_name()
		if player_name ~= "Server_IT_Admin" and player_name ~= "Hamlet" and player_name ~= "Father" then
			core.kick_player(player_name, "Players Are not allowed on Right now (Try again in 5 minutes) ")
		end
	end)
	minetest.register_abm({ -- Snow into white porcelain --
		nodenames = {"default:snowblock"},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			if pos.y < 0 then
				minetest.set_node(pos, {name = "plasters:plaster_raw"})
			end
		end
	})
	minetest.register_abm({ -- Ice into blue Procelain --
		nodenames = {"default:ice"},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			if pos.y > 1.5 then
				minetest.set_node(pos, {name = "porcelain:" .. IceReplacement})
			end
		end
	})
	minetest.register_abm({ -- Ice into blue Procelain --
		nodenames = {"group:ice"},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			local name = {}
			local i = 1
			if pos.y > 1.5 then
				for str in string.gmatch(node.name, "([^_]+)") do
					name[i] = str
					i = i +1

				end
				
				if name[2] == "ice" then
					if name[3] == nil then
						minetest.swap_node(pos, {name = name[1] .. "_" .. IceReplacement, param1 = node.param1, param2 = node.param2})
					elseif name[4] == nil then
						print(name[1] .. "_" .. IceReplacement .. "_" .. name[3])
						minetest.swap_node(pos, {name = name[1] .. "_" .. IceReplacement .."_" .. name[3], param1 = node.param1, param2 = node.param2})
					elseif name[5] == nil then
						print(name[1] .. "_" .. IceReplacement .."_" .. name[3])
						minetest.swap_node(pos, {name = name[1] .. "_" .. IceReplacement .."_" .. name[3] .. "_" .. name[4], param1 = node.param1, param2 = node.param2})
					end
				end
			
			end
		end
	})
	runreplacement:set_string("ranReplace", "True")
end