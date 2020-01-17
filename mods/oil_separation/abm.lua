----------------------------------------------------------------------------
--                       OIL SEPARATION: ABM'S
----------------------------------------------------------------------------
local neighbors = { --Neighbor definition
    {x= 1,y= 0,z= 0}, --East   (1)
    {x=-1,y= 0,z= 0}, --West   (2)
    {x= 0,y= 0,z= 1}, --North  (3)
    {x= 0,y= 0,z=-1}, --South  (4)
    {x= 0,y=-1,z= 0}, --Under  (5)
    {x= 0,y= 1,z= 0}, --Above  (6)
}

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

--GROUP:OIL-- Make oil float on water, Make oil fall into water, Oil drops
minetest.register_abm({
    label = "Oil Dynamics",
    nodenames = {"group:oil"},
    interval = 10,
    chance = 3,
    action = function(pos, node)
        --Make oil float on water
        local above_pos = {x=pos.x, y= pos.y+1, z=pos.z}
        local above_node = minetest.get_node(above_pos)
        if above_node.name == "default:water_source" or above_node.name == "default:river_water_source" then
            minetest.set_node(above_pos, node)
            minetest.set_node(pos, above_node)
            return
        end

        local under_pos = vector.add(pos, neighbors[5])
        for i=1, 4 do
            local chk_pos = vector.add(pos, neighbors[i])
            local chk_node = minetest.get_node(chk_pos)

            --Flowing water to water source 
            if chk_node.name == "default:water_flowing" then
                minetest.set_node(chk_pos, {name = "default:water_source"})
            end

            if chk_node.name == "default:river_water_flowing" then
                minetest.set_node(chk_pos, {name = "default:river_water_source"})
            end

            --Oil sinks to water surface
            if minetest.get_item_group(chk_node.name, "oil_flowing") >= 1 and
               (minetest.get_node(under_pos).name == "default:water_source" or minetest.get_node(under_pos).name == "default:river_water_source") then
                minetest.remove_node(pos)
                minetest.set_node(under_pos, node)
                return
            end
        end

        --Drop oil down if flowing oil is under it
        if minetest.get_item_group(minetest.get_node(under_pos).name, "oil_flowing") >= 1 then
            minetest.remove_node(pos)
            minetest.set_node(under_pos, node)
        end
    end,
})

--GROUP:OIL_FLOWING-- set flowing oil to water_source if touching water_source
minetest.register_abm({
    label = "Flowing Oil Dynamics",
    nodenames = {"group:oil_flowing"},
    interval = 3,
    chance = 2,
    action = function(pos, node)
        for i=1, #neighbors - 2 do
            local chk_pos = vector.add(pos, neighbors[i])
            local chk_node = minetest.get_node(chk_pos)
            if chk_node.name == "default:water_source" then
                minetest.set_node(pos, {name = "default:water_source"})
                return
            elseif chk_node.name == "default:river_water_source" then
                minetest.set_node(pos, {name = "default:river_water_source"})
            end
        end
    end,
})