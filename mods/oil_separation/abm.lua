----------------------------------------------------------------------------
--                       OIL SEPARATION: ABM SETTINGS
----------------------------------------------------------------------------
local neighbors = { --Neighbor definition
    {x= 1,y= 0,z= 0}, --East   (1)
    {x=-1,y= 0,z= 0}, --West   (2)
    {x= 0,y= 0,z= 1}, --North  (3)
    {x= 0,y= 0,z=-1}, --South  (4)
    {x= 0,y=-1,z= 0}, --Under  (5)
    {x= 0,y= 1,z= 0}, --Above  (6)
}

local freezes_oil = {"default:ice", "seasons:ice", "default:snowblock", "default:snow", "seasons:flowing_ice"}

--ARRAY CONTAINS STRING-- Used to find if a string exists in a table
local function has_string(array, string)
    for i = 1, #array do
        if array[i] == string then 
            return true 
        end
    end
    return false
end

----------------------------------------------------------------------------
--                       OIL SEPARATION: ABM'S
----------------------------------------------------------------------------
--NODE:OILY PASTE-- Controls oily paste's reaction to the environment
minetest.register_abm({
    label = "Oily Paste Dynamics",
    nodenames = {"oil_separation:seed_paste_oily"},
	interval = 9,
	chance = 2,
    action = function(pos)
        local node = minetest.get_node(pos)

        --Oily pastes sink below dry paste
        local under_pos = vector.add(pos,{x=0,y=-1,z=0})
        local under_node = minetest.get_node(under_pos)
        if under_node and minetest.get_item_group(under_node.name, "waste") > 0 then
            minetest.set_node(pos,{name = "oil_separation:seed_paste_dry"})
            minetest.set_node(under_pos, node)
            return
        end

        --Oily dries out if light is too bright
        local above_pos = vector.add(pos,{x=0,y=1,z=0})
        local above_node = minetest.get_node(above_pos)
        local light_level = minetest.get_node_light(above_pos) or 0
        if light_level > 13 then
            minetest.set_node(pos, {name = "oil_separation:seed_paste_dry"})
        end
    end,
})

--GROUP:OIL-- Control dynamics of oil source
minetest.register_abm({
    label = "Source Oil Dynamics",
    nodenames = {"group:oil"},
    interval = 2,
    chance = 2,
    action = function(pos, node)

        --Dynamics requiring flowing or water
        if minetest.find_node_near(pos, 1, {"group:water", "group:oil_flowing"}) then

            --Make Oil Float to Surface or scoot over (must be significantly slower than the refill speed of water)
            if math.random() <= 1/4 then --delay
                local above_pos = {x=pos.x, y= pos.y+1, z=pos.z}
                local above_node = minetest.get_node(above_pos)
                if has_string({"default:water_source", "default:river_water_source"}, above_node.name) then
                    minetest.set_node(above_pos, node)
                    minetest.set_node(pos, above_node)
                    return
                elseif minetest.get_item_group(above_node.name, "oil") >= 1 then
                    for i = 1, 4 do
                        local chk_pos = vector.add(pos, neighbors[i])
                        local chk_node = minetest.get_node(chk_pos)
                        if has_string({"default:water_source", "default:river_water_source"}, chk_node.name) then
                            minetest.set_node(chk_pos, node)
                            minetest.set_node(pos, chk_node)
                            return
                        end
                    end
                end
            end

            --Make Oil Fall or Sink to Surface
            local NE_pos = {x=pos.x+1, y=pos.y, z=pos.z+1}
            local SW_pos = {x=pos.x-1, y=pos.y, z=pos.z-1}
            local under_pos = {x=pos.x, y= pos.y-1, z=pos.z} 
            local under_node = minetest.get_node(under_pos)
            local fall_test = has_string({"default:water_flowing", "default:river_water_flowing", "air"}, under_node.name) or
                              minetest.get_item_group(under_node.name, "oil_flowing") >= 1
            local sink_test = has_string({"default:water_source", "default:river_water_source"}, under_node.name) and
                              #minetest.find_nodes_in_area(SW_pos, NE_pos, {"group:water"}) < 1 and 
                              #minetest.find_nodes_in_area(SW_pos, NE_pos, {"group:oil_flowing"}) >= 1
            if fall_test or sink_test then
                minetest.remove_node(pos)
                minetest.set_node(under_pos, node)
                return
            end
            
            if not (minetest.get_item_group(under_node.name, "catches_oil") >= 1) then --oils don't move horizontally on some material
                
                --Oil flows Downhill
                local lower_flow = minetest.find_nodes_in_area(
                    {x=pos.x-1, y=pos.y-1, z=pos.z-1},
                    {x=pos.x+1, y=pos.y-1, z=pos.z+1},
                    {"group:oil_flowing","default:water_flowing","default:river_water_flowing"}
                )
                if #lower_flow >= 1 then
                    local dest_pos = lower_flow[math.random(1,#lower_flow)]
                    minetest.remove_node(pos)
                    minetest.set_node(dest_pos, node)
                    return
                end

                --Oil finds level
                local nei_flow = minetest.find_nodes_in_area(SW_pos, NE_pos, {"group:oil_flowing"}) --prefer itself
                if #nei_flow > 6 then --too many flowing oil nodes
                    nei_flow = {} 
                elseif #nei_flow < 1 then -- if not itself, find lowest level of flowing water
                    local lowest = 100
                    for i = 1, 4 do
                        local chk_pos = vector.add(pos, neighbors[i])
                        local chk_node = minetest.get_node(chk_pos)
                        if has_string({"default:water_flowing", "default:river_water_flowing"}, chk_node.name) then
                            if chk_node.param2 < lowest then
                                lowest = chk_node.param2
                                nei_flow = {chk_pos}
                            elseif chk_node.param2 == lowest then
                                nei_flow[#nei_flow+1] = chk_pos
                            end
                        end
                    end
                end
                if #nei_flow >=1 then --select new position
                    local dest_pos = nei_flow[math.random(1,#nei_flow)]
                    minetest.remove_node(pos)
                    minetest.set_node(dest_pos, node)
                    return
                end
            end
        end

        --Freeze Oil
        if minetest.find_node_near(pos, 2, freezes_oil) and not oil_separation.is_heated(pos,3) then
            local frozen_name = minetest.registered_nodes[node.name].oil_separation_settings.oil_block
            minetest.set_node(pos, {name = frozen_name})
            minetest.sound_play("oil_separation_oil_block_freeze",{gain = 0.5, max_hear_distance = 10, loop = false, pos = pos,})
            local chance = 1/oil_separation.energy_loss_chance --Occasionally remove ice
            if math.random() <= chance then
                local freeze_pos = minetest.find_node_near(pos, 2, freezes_oil)
                minetest.set_node(freeze_pos, {name = "air"})
            end
        end
    end,
})

--GROUP:OIL FLOWING-- Flowing water removes flowing oil
minetest.register_abm({
    label = "Flowing Oil Dynamics",
    nodenames = {"group:oil_flowing"},
    neighbors = {"group:water"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        local water = minetest.find_node_near(pos, 1, {"group:water"})
        if not water then return end
        local flowing_type = minetest.registered_nodes[minetest.get_node(water).name].liquid_alternative_flowing
        for i = 1, 6 do
            local chk_pos = vector.add(pos, neighbors[i])
            local chk_node = minetest.get_node(chk_pos)
            if minetest.get_item_group(chk_node.name, "water") >= 1 then
                minetest.set_node(pos, {name = flowing_type})
                return
            end
        end
    end,
})

--GROUP:OIL_BLOCK-- Liquify oil_block if near heat
minetest.register_abm({
    label = "Oil Block Dynamics",
    nodenames = {"group:oil_block"},
    interval = 15,
    chance = 2,
    action = function(pos, node)
        if oil_separation.is_heated(pos,3) then
            local melted_name = minetest.registered_nodes[node.name].oil_separation_settings.oil_source
            minetest.set_node(pos, {name = melted_name})
            minetest.sound_play("oil_separation_oil_block_melt",{gain = 0.5, max_hear_distance = 10, loop = false, pos = pos,})
            oil_separation.cool_lava(pos,3)
        end
    end,
})