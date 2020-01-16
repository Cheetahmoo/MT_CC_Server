local particleDist = 10

if seasons.season == "winter" or seasons.season == "fall" then
    local timer=0
    minetest.register_globalstep(function(dtime)
        if seasons.season == "fall" and (seasons.fallTime-(seasons.time/60) > 2 or seasons.time == 0)then
            return
        end
        if not seasons.snowstormSnow then
            return
        end
        timer = timer+dtime
        if timer < 1 then
            return
        end
        timer = 0
        for _,player in ipairs(minetest.get_connected_players()) do
        
            local player_pos = player:get_pos()
            if player_pos.y <= seasons.minHeight then
                return
            end

            local pos1 = {x = (player_pos.x-10)+(player:get_player_velocity().x*2), y=player_pos.y + 5, z=(player_pos.z -10)+(player:get_player_velocity().z*2)}
            local pos2 = {x = (player_pos.x+10)+(player:get_player_velocity().x*2), y=player_pos.y + 5, z=player_pos.z +10+(player:get_player_velocity().z*2)}

            for x=pos1.x, pos2.x do
                for z=pos1.z, pos2.z do
                    local raycast = minetest.raycast({x=x,y= player_pos.y+5, z=z}, {x=x,y= player_pos.y+25, z=z},false, true)
                    local hit = raycast:next()
                    local nodeLight=minetest.get_node_light({x=x,y= player_pos.y+5, z=z})
                    if not hit and nodeLight and nodeLight >=14 then
                        if  math.random(0,4) == 1 and seasons.season == "winter" then
                            minetest.add_particle({
                                pos = {x = x+math.random(), y = pos1.y, z = z+math.random()},
                                velocity = {x = 0, y = -(math.random()+math.random(0.1,0.5)), z = 0},
                                acceleration = {x = 0, y = 0, z = 0},
                                expirationtime = 10,
                                size = 0.8,
                                collisiondetection = true,
                                collision_removal = true,
                                vertical = false,
                                texture = "snowdrift_snowflake" ..
                                    math.random(1, 12) .. ".png",
                                playername = player:get_player_name()
                            })
                        elseif math.random(0,8) == 1 then
                            minetest.add_particle({
                                pos = {x = x+math.random(), y = pos1.y, z = z+math.random()},
                                velocity = {x = 0, y = -(math.random()+math.random(0.1,0.5)), z = 0},
                                acceleration = {x = 0, y = 0, z = 0},
                                expirationtime = 10,
                                size = 0.8,
                                collisiondetection = true,
                                collision_removal = true,
                                vertical = false,
                                texture = "snowdrift_snowflake" ..
                                    math.random(1, 12) .. ".png",
                                playername = player:get_player_name()
                            })
                        end
                    end
                end
            end
        end
    end)
end
if seasons.season == "fall" then
    minetest.register_abm({--fall Particles
		nodenames = {"group:leaves"},
		interval = 1,
		chance = 70,
		action = function(pos, node)
            local under = {x=pos.x,y=pos.y-1,z=pos.z}
            if minetest.get_node(under).name ~= "air" or node.name == "default:pine_needles" then
                return
            end
            for _,player in ipairs(minetest.get_connected_players()) do
                local player_pos = player:get_pos()
                if math.abs(player_pos.x-pos.x) <= particleDist or math.abs(player_pos.y-pos.y) <= particleDist or math.abs(player_pos.y-pos.y) <= particleDist then
                    minetest.add_particle({
                        pos = {x = under.x+math.random(), y = under.y, z = under.z+math.random()},
                        velocity = {x = math.random(0.1,0.3), y = -(math.random(0.3,0.5)), z = 0},
                        acceleration = {x = 0, y = 0, z = 0},
                        expirationtime = 10,
                        size = 2,
                        collisiondetection = true,
                        collision_removal = true,
                        vertical = false,
                        texture = "leaf_" ..
                            math.random(1, 7) .. ".png",
                        playername = player:get_player_name()
                    })
                end
            end
		end
	})
end