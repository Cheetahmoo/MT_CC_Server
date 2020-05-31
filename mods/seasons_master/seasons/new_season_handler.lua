-- keeps track if chunk has run abm or not
local chucksUpdated = {}

local chance = 15
local interval = 5

local function cChance()
    
    if(math.random(1,interval) == 1) then
        return true
    end

    return false
end


local function add_snow(_pos, _blockPos)
   

    local above = {x=_pos.x,y=_pos.y+1, z=_pos.z}
    local lastTime = chucksUpdated[_blockPos.x][_blockPos.z].LastU

    if lastTime == nil then
        return
    end

    -- calulates a random chance to wether or not to add the snow
    --minetest.chat_send_all("Add_snow: chances: " ..  (minetest.get_gametime()-lastTime)/interval)
    if(minetest.get_node(above).name == "air") then
        for i=0, (minetest.get_gametime()-lastTime)/interval do
            if cChance() then
                minetest.set_node(above, {name = "default:snow"})
                chucksUpdated[_blockPos.x][_blockPos.z].current = minetest.get_gametime()
                return true
            end
        end
    end


    chucksUpdated[_blockPos.x][_blockPos.z].current = minetest.get_gametime()
end

local function Update(pos, node)
    --Get Block(chunk) pos
    local blockPos = {x=math.floor(pos.x/16), z=math.floor(pos.z/16)}

    if (chucksUpdated[blockPos.x] == nil or chucksUpdated[blockPos.x][blockPos.z] == nil or chucksUpdated[blockPos.x][blockPos.z].LastU+ interval <= minetest.get_gametime() ) then
        if(chucksUpdated[blockPos.x] == nil) then
            chucksUpdated[blockPos.x] = {}
        end

        if chucksUpdated[blockPos.x][blockPos.z] == nil then
            chucksUpdated[blockPos.x][blockPos.z] = {LastU = seasons.lastSeasonTime, current = 1}
        end
        
        if (chucksUpdated[blockPos.x][blockPos.z].current > minetest.get_gametime() + 1) then
            chucksUpdated[blockPos.x][blockPos.z].LastU = chucksUpdated[blockPos.x][blockPos.z].current
            return
        end
        add_snow(pos, blockPos)
    end
end



minetest.register_lbm({
    name = "seasons:ading_stone",
    nodenames = {"default:dirt_with_grass"},
    run_at_every_load = true,
    action = function(pos, node)
       Update(pos, node)
    end
})

minetest.register_abm({-- replaces apples with rotten
		nodenames = {"default:dirt_with_grass"},
		interval = interval,
		chance = 1,
		action = function(pos, node)
			Update(pos, node)
		end
	})

