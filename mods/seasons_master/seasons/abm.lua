
local addsnowBlock = true
seasons.snowstormSnow = true

local flowers = {"flowers:rose","flowers:tulip","flowers:dandelion_yellow","flowers:geranium","flowers:viola", "flowers:dandelion_white"} 
local flowersDry = {"flowers:rose_dry","flowers:tulip_dry","flowers:dandelion_yellow_dry","flowers:geranium_dry","flowers:viola_dry", "flowers:dandelion_white_dry"} 


local function get_nodedef_field(nodename, fieldName)
	if not minetest.registered_nodes[nodename] then
		return
	end
	return minetest.registered_nodes[nodename][fieldName]
end

local function Add_snow_above(_pos, addBlock, replaceNods)
	
	local raycast = minetest.raycast(_pos, {x = _pos.x, y = 60, z = _pos.z},false, true)
	local hit = raycast:next()
	if hit then	
		return
	end
	raycast = minetest.raycast(_pos, {x = _pos.x, y = _pos.y - 35, z = _pos.z},false, true)
	hit = raycast:next()
	if hit then	
		local hitNode = {x=hit.above.x, y=hit.above.y-1, z=hit.above.z}
		if hitNode.y <= seasons.minHeight then
			return
		end
		local name = minetest.get_node(hit.above).name
		local hitName = minetest.get_node(hitNode).name
		local hitNameBelow = minetest.get_node({x=hit.above.x, y=hit.above.y-2, z=hit.above.z}).name
		if minetest.get_node_group(hitName, "no_snow_cover") == 0 then
			if (name == "air" or minetest.get_node_group(hitName, "farming_soil") >= 1) and hitName ~= "default:snowblock" and (get_nodedef_field(hitName, "drawtype") == "normal" or minetest.get_node_group(hitName, "leaves") >=1 or minetest.get_node_group(hitName, "snow_cover") >=1 )then
				minetest.set_node(hit.above, {name = "default:snow"})
			elseif hitName == "default:snow" and minetest.get_node_group(hitNameBelow, "leaves") == 0 then
				minetest.set_node(hitNode, {name = "default:snowblock"})
			end
		end
	end

	--[[
	if not replaceNods then
		if name == "air" then
			minetest.set_node(above, {name = "default:snow"})
		elseif addBlock and name == "default:snow" then
			minetest.set_node(above, {name = "default:snowblock"})
		end
	else
		if addBlock and name == "default:snow" then
			minetest.set_node(above, {name = "default:snowblock"})
		elseif name == "default:snow" then
			minetest.set_node(above, {name = "default:snow"})
		end
	end--]]

end

local function Change_plants_Frozen(pos)
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local name = minetest.get_node(above).name
	for item,_ in pairs(flowers) do
		if flowers[item] == name and pos.y > seasons.minHeight then
			minetest.set_node(above, {name = flowersDry[item]})
		end
	end
end
local function Change_plants_unFrozen(pos)
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local name = minetest.get_node(above).name
	for item,_ in pairs(flowersDry) do
		if flowersDry[item] == name and pos.y > seasons.minHeight then
			minetest.set_node(above, {name = flowers[item]})
		end
	end
end

local function Remove_Snow(pos, node)
	if pos.y <= seasons.minHeight then
		return
	end
	if node.name == "default:snow" and minetest.get_node(pos).name ~= "CONTENT_IGNORE" then
		minetest.set_node(pos, {name = "air"})
	elseif node.name == "default:snowblock" then
		minetest.set_node(pos, {name = "default:snow"})
	end
end

local function though_node(pos, thouhg_to)
	if pos.y <= seasons.minHeight then
		return
	end

	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local name = minetest.get_node(above).name
	if name ~= "default:snowblock" and name ~= "default:snow" then
		minetest.set_node(pos, {name = thouhg_to})
		Change_plants_unFrozen(pos)
	else
		Remove_Snow(above, minetest.get_node(above))
	end
end

local function FreezeSoil(pos)
	if pos.y <= seasons.minHeight then
		return
	end
	minetest.set_node(pos, {name = "seasons:soil_wet_frozen"})
	local above = {x = pos.x, y = pos.y + 1, z = pos.z}
	local aboveNode = minetest.get_node(above)
	--minetest.log("warning", aboveNode.name .. ": ".. minetest.get_item_group(aboveNode.name, "replacedbysnow"))
	if minetest.get_item_group(aboveNode.name, "replacedbysnow") >=1 then
		minetest.set_node(above, {name="air"})
	end
end



-------------------------------------------------winter-------------------------------------------
if seasons.season == "winter" then
	-- Grass begin to turn to snow. Snow flakes begin to form. Water begin to freeze
	minetest.register_abm({-- replaces apples with rotten
		nodenames = {"default:apple"},
		interval = 1,
		chance = 1,
		action = function(pos, node)
			if pos.y <= seasons.minHeight then
				return
			end
			if node.param2 == 0 and minetest.get_node(pos).name ~= "ignore" then
				minetest.set_node(pos, {name = "seasons:apple_roten"})
			end
		end
	})
	--Add snow ontop of group snow_cover
	minetest.register_lbm({
		name = "seasons:add_snow_nodes",
		nodenames = {"air"},
		run_at_every_load = true,
		action = function(pos, node)
			if pos.y == 25 or pos.y == 50 or pos.y == 75 then
				Add_snow_above(pos, true)
			end
		end
	})

	-- adds snow to anything of group snow_cover
	seasons.snowstorm = true
	local timer = 0
	minetest.register_globalstep(function(dtime)
		
		if not seasons.snowstorm then
			for _,player in ipairs(minetest.get_connected_players()) do
				skybox.set(player, 0)
				--player:set_eye_offset({x=0,y=0,z=0}, {x=0,y=0,z=0})
				--player:set_eye_offset({x=0,y=-7,z=0}, {x=0,y=-50,z=-5})
				--player:set_properties({collisionbox = {-0.3, 0.0, -0.3, 0.3, 0.4, 0.3}})
			end
			return
		end
		timer = timer+dtime
		if(timer<1) then
			return
		end

		timer = 0
		for _,player in ipairs(minetest.get_connected_players()) do
			skybox.set(player, 1)
		end
	end)

	local nextStromTime = math.random(60*15,60*27)
	local stimer = 0
	minetest.register_globalstep(function(dtime)
		stimer = stimer+dtime
		if(stimer>nextStromTime-5 and seasons.snowstorm == false) then
			seasons.snowstormSnow = true
		end
		if(stimer<nextStromTime) then
			return
		end
		if seasons.snowstorm then
			seasons.snowstorm = false
			seasons.snowstormSnow = false
			nextStromTime = math.random(120,300)
		else
			seasons.snowstorm = true
			nextStromTime = math.random(120,300)
		end
		stimer = 0
	end)

	-- replaces dirt_with_grass with dirt_with_snow
	minetest.register_lbm({
		name = "seasons:add_snow_ground",
		nodenames = {"default:dirt_with_grass"},
		run_at_every_load = true,
		action = function(pos, node)	
			if pos.y <= seasons.minHeight then
				return
			end	
			minetest.set_node(pos, {name = "default:dirt_with_snow"})
			--Add_snow_above(pos, true)
			Change_plants_Frozen(pos)
		end
	})
	minetest.register_lbm({-- replaces Water with ice aka Freeze Water
		name = "seasons:freeze_water",
		nodenames = {"default:water_source", "default:water_flowing"},
		run_at_every_load = true,
		action = function(pos, node)
			if pos.y <= seasons.minHeight then
				return
			end
			local air = minetest.find_node_near(pos, 1, "air")
			if air then
				if node.name == "default:water_flowing" then
					minetest.swap_node(pos, {name = "seasons:flowing_ice"})
				else
					minetest.set_node(pos, {name = "default:ice"})
				end
				--Add_snow_above(pos)
			end
		end
	})


	--[[minetest.register_lbm({ -- add Snow Ontop Of leaves
		name = "seasons:change_leaves_w",
		nodenames = {"group:leaves"},
		run_at_every_load = true,
		action = function(pos, node)
			Add_snow_above(pos)
		end
	})--]]
	
	
	
	minetest.register_abm({-- Places snow ontop of the soil --
		nodenames = {"seasons:soil_wet_frozen"},
		interval = 1,
		chance = 25,
		action = function(pos, node)
			if pos.y <= seasons.minHeight then
				return
			end
			Add_snow_above(pos, false, true)
		end
	})
end

minetest.register_abm({
	nodenames = nodenames = {"farming:soil", 'farming:soil_wet', "seasons:soil_wet_frozen", "group:farming_soil"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		--Checks to see if the position of the node to add snow to is above the min height
		if pos.y <= seasons.minHeight then
			return
		end

		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		
		if  seasons.season == "winter" then
			local pos1 = {x = pos.x -1, y = pos.y-1, z = pos.z -1}
			local pos2 = {x = pos.x +1, y = pos.y+1, z = pos.z +1}	
			local warm_nodes = minetest.find_nodes_in_area(pos1, pos2, "group:heatable")
			
			--minetest.set_node(warm_node, {name = "defualt:stone"})
			if not warm_nodes then
				FreezeSoil(pos)
			else
				for i = 1, #warm_nodes do
					local heat_level =  minetest.get_meta(warm_nodes[i]):get_float("heatLevel")
					if heat_level > 0 then
						if node.name == "seasons:soil_wet_frozen" then
							though_node(pos, "farming:soil_wet")
						end
						return
					end
				end
				FreezeSoil(pos)
			end
		elseif node.name == "seasons:soil_wet_frozen" then
			minetest.set_node(pos, {name = "farming:soil_wet"})
		end
	end
})

--------------------------------------------spring------------------------------------------------------
--[[Leaves begin to change. Snow blocks and flakes begin to melt. Force fields defrost. Ice begins to melt
if seasons.season == "spring" then
	--
	-- LBM
	--
	minetest.register_lbm({-- replaces Water with ice aka Freeze Water
		name = "seasons:though_snow",
		nodenames = {"default:snow", "default:snowblock"},
		run_at_every_load = true,
		action = function(pos, node)
			Remove_Snow(pos, node)
		end
	})
	minetest.register_lbm({-- replaces Water with ice aka Freeze Water
		name = "seasons:thouhg_ice",
		nodenames = {"default:ice", "seasons:flowing_ice"},
		run_at_every_load = true,
		action = function(pos, node)
			if node.name == "seasons:flowing_ice" then
				though_node(pos, "default:water_flowing")
			else
				though_node(pos, "default:water_source")
			end
		end
	})
	minetest.register_lbm({-- replaces Water with ice aka Freeze Water
		name = "seasons:thouhg_ice_to_air",
		nodenames = {"seasons:ice"},
		run_at_every_load = true,
		action = function(pos, node)
			though_node(pos, "air")
		end
	})
	minetest.register_lbm({-- replaces dirt_with_grass with dirt_with_snow
		name = "seasons:add_snow_ground",
		nodenames = {"default:dirt_with_snow"},
		run_at_every_load = true,
		action = function(pos, node)		
			though_node(pos, "default:dirt_with_grass")
		end
	})
end--]]

if seasons.season == "spring" or seasons.season == "summer" or seasons.season == "fall" then
	minetest.register_lbm({-- replaces apples with rotten
		name = "seasons:change_apples",
		nodenames = {"seasons:apple_roten"},
		run_at_every_load = true,
		action = function(pos, node)
			--Checks to see if the position of the node to add snow to is above the min height
			if pos.y <= seasons.minHeight then
				return
			end
			if node.param2 == 0 then
				minetest.set_node(pos, {name = "default:apple"})
			end
		end
	})
	minetest.register_lbm({-- Melt All Of Winter
		name = "seasons:remove_all_snow_ice",
		nodenames = {"default:snow", "default:snowblock"},
		run_at_every_load = true,
		action = function(pos, node)
			--Checks to see if the position of the node to add snow to is above the min height
			if pos.y <= seasons.minHeight then
				return
			end
			if node.name == "default:ice" then
				minetest.set_node(pos, {name = "default:water_source"})
			else
				minetest.set_node(pos, {name = "air"})
			end
		end
	})
	minetest.register_lbm({-- Melt All Of Winter
		name = "seasons:remove_all_ice",
		nodenames = {"default:ice", "seasons:flowing_ice", "seasons:ice"},
		run_at_every_load = true,
		action = function(pos, node)
			--Checks to see if the position of the node to add snow to is above the min height
			if pos.y <= seasons.minHeight then
				return
			end
			if node.name == "default:ice" then
				minetest.set_node(pos, {name = "default:water_source"})
			elseif node.name == "seasons:flowing_ice" then
				minetest.swap_node(pos, {name = "default:water_flowing"})
			elseif node.name == "default:dirt_with_snow" then
				minetest.set_node(pos, {name = "default:dirt_with_grass"})
			else
				minetest.set_node(pos, {name = "air"})
			end
		end
	})
	minetest.register_lbm({-- Melt All Of Winter
		name = "seasons:remove_snow_with_dirt",
		nodenames = {"default:dirt_with_snow"},
		run_at_every_load = true,
		action = function(pos, node)
			--Checks to see if the position of the node to add snow to is above the min height
			if pos.y <= seasons.minHeight then
				return
			end
			Change_plants_unFrozen(pos)
			minetest.set_node(pos, {name = "default:dirt_with_grass"})
		end
	})
end
--[[
--Soil
minetest.register_abm({ -- Any Frozen Soil that is above -20 turns to soil --
	nodenames = {"seasons:soil_wet_frozen"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if (seasons.season == "spring" or seasons.season == "summer" or seasons.season == "fall") then
			minetest.set_node(pos, {name = "farming:soil_wet"})
		else
			local pos1 = {x = pos.x -1, y = pos.y-1, z = pos.z -1}
			local pos2 = {x = pos.x +1, y = pos.y+1, z = pos.z +1}	
			local warm_nodes = minetest.find_nodes_in_area(pos1, pos2, "group:heatable")
			if warm_nodes then
				for i = 1, #warm_nodes do
					local meta = minetest.get_meta(warm_nodes[i])
					local heat_level = meta:get_float("NewHeatLevel")
					if heat_level > 0 then
						minetest.set_node(pos, {name = "farming:soil_wet"})
						return
					end
				end
			end
		end
	end
})

------Force all Snow to Grass-----
-- dirt with grass
minetest.register_abm({
	nodenames = {"default:dirt_with_snow"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if (seasons.season == "spring" or seasons.season == "summer" or seasons.season == "fall") and (pos.z <= zrange and pos.z >= (zrange * -1)) then
			minetest.set_node(pos, {name = "default:dirt_with_grass"})
			for item,_ in pairs(flowersDry) do
				if flowersDry[item] == name then
					minetest.set_node(above, {name = flowers[item]})
				end
			end
		else
			local pos1 = {x = pos.x -1, y = pos.y-1, z = pos.z -1}
			local pos2 = {x = pos.x +1, y = pos.y+1, z = pos.z +1}	
			local warm_nodes = minetest.find_nodes_in_area(pos1, pos2, "group:heatable")
			if warm_nodes then
				for i = 1, #warm_nodes do
					local meta = minetest.get_meta(warm_nodes[i])
					local heat_level = meta:get_float("NewHeatLevel")
					if heat_level > 0 then
						minetest.set_node(pos, {name = "default:dirt_with_grass"})
						for item,_ in pairs(flowersDry) do
							if flowersDry[item] == name then
								minetest.set_node(above, {name = flowers[item]})
							end
						end
						return
					end
				end
			end
		end
	end
})



--]]