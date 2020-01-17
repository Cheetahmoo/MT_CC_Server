--TEMPORARALY ADD PORCELAINS TO REGISTERED NODES
--[[
local future_porcelains = {
    {"red", "red"},
    {"brown", "brown"},
    {"orange", "orange"},
    {"yellow", "yellow"},
    {"avocado", "green"},
    {"green", "dark_green"},
    {"cyan", "cyan"},
    {"blue", "blue"},
    {"violet", "violet"},
    {"black", "black"},
    {"white", "white"},
}

for i, row in ipairs(future_porcelains) do
    minetest.registered_nodes[#minetest.registered_nodes +1] = "porcelain:porcelain_"..row[1]
end
--]]


---------------------------------------------------------------------------------
--                          REPLACE PLASTERS
---------------------------------------------------------------------------------
--Plaster name replacement dictionary
local plaster_change = {
    {"plasters:", "plaster:"},
    {"raw", "white"},
    {"dark_grey", "grey"},
    {"black", "black"},
    {"moreblocks", "plaster"},
    {"cyan", "cyan"},
    {"dark_green", "dark_avocado"},
    {"green", "avocado"},
    {"red", "dark_red"},
    {"magenta", "red"},
    {"pink", "red"},
    {"orange", "dark_orange"},
}

--Lists of all registered plasters
local replace_plaster = {}
for name, def in pairs(minetest.registered_nodes) do
    if string.find(name, "plaster") and not string.find(name, "plaster:") then
        replace_plaster[#replace_plaster+1] = name
    end
end

--For Plasters
for i, name in ipairs(replace_plaster) do
    if minetest.registered_nodes[name] then
        minetest.register_abm({
            nodenames = {name},
            interval = 1,
            chance = 1,
            action = function(pos, node)
                --Build new name
                local new_name = node.name
                for i, row in ipairs(plaster_change) do
                    new_name = string.gsub(new_name, row[1], row[2])
                end

                --Assign new name
                if new_name and minetest.registered_nodes[new_name] then
                    print("new name assigned")
                    minetest.swap_node(pos,{name = new_name, param1 = node.param1, param2 = node.param2})
                end
            end
        })
    end
end

---------------------------------------------------------------------------------
--                          REPLACE PORCELAIN
---------------------------------------------------------------------------------
--Porcelain name replacement dictionary
local porcelain_change = {
    ["red_porcelain"] = "porcelain_red",
    ["black_porcelain"] = "porcelain_black",
    ["moreblocks:"] = "porcelain:",
    ["white_porcelain"] = "porcelain_white",
    ["blue_porcelain"] = "porcelain_blue",
    ["yellow_porcelain"] = "porcelain_yellow",
    ["brown_porcelain"] = "porcelain_brown",
    ["orange_porcelain"] = "porcelain_orange",
}

local cyan_change = {
    ["porcelain:"] = "plaster:",
    ["moreblocks:"] = "plaster:",
    ["cyan_porcelain"] = "plaster_blue",
}

--Lists of all registered porcelains
local replace_porcelain = {}
for name, def in pairs(minetest.registered_nodes) do
    if string.find(name, "porcelain") then
        replace_porcelain[#replace_porcelain+1] = name
    end
end

--For Porcelain
for i, name in ipairs(replace_porcelain) do
    if minetest.registered_nodes[name] then
        minetest.register_abm({
            nodenames = {name},
            interval = 1,
            chance = 1,
            action = function(pos, node)
                
                --Build new name
                local new_name = node.name
                if string.find(node.name, "cyan") then
                    for key, replacement in pairs(cyan_change) do
                        new_name = string.gsub(new_name, key, replacement)
                    end
                else
                    for key, replacement in pairs(porcelain_change) do
                        new_name = string.gsub(new_name, key, replacement)
                    end
                end
                
                --Assign new name
                if new_name and new_name ~= node.name then
                    minetest.registered_nodes[#minetest.registered_nodes +1] = new_name
                    print(new_name)
                    --if minetest.registered_nodes[new_name] then
                    print("new name assigned")
                    minetest.swap_node(pos,{name = new_name, param1 = node.param1, param2 = node.param2})
                    --end
                end
                
            end
        })
    end
end