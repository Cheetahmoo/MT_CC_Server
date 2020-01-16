---- functions

-- Utilitys
function seasons.Is_Item_In_Arry(_item, _array)
	for i=1,#_array do
		if(_array[i] == _item)then
			return true
		end
	end
	return false	
end

-----player

function seasons.isPlayerInWarmAir(_pos)
	
	local node = minetest.get_node(_pos)
	local pos1 = {x = _pos.x -1, y = _pos.y, z = _pos.z -1}
	local pos2 = {x = _pos.x +1, y = _pos.y+1, z = _pos.z +1}

	if(minetest.find_nodes_in_area(pos1, pos2, "group:heatable")[1] ~= nil) then
		return true
	end
	return false
end

--gets the players armor from 3d_armor mod pack
function seasons.get_play_armor(_player)
	local armorProtection = 0
	local name, player_inv, armor_inv, pos = armor:get_valid_player(_player, "[update_armor]")
	local num = 1
	for i=1, 6 do
		local stack = player_inv:get_stack("armor", i)
		local armorName = stack:get_name()
		
		if not (stack == nil) then
			if armorName == "seasons:boots_wool" then
				armorProtection = armorProtection + 10				
			end
			if armorName == "seasons:chestplate_wool"then
				armorProtection = armorProtection + 15

			end
			if armorName == "seasons:helmet_wool"then
				armorProtection = armorProtection + 15
			end
			if armorName == "seasons:leggings_wool"then
				armorProtection = armorProtection + 10
			end			
		end		
	end
	return armorProtection
end