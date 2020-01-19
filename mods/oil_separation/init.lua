----------------------------------------------------------------------------
--                   OIL SEPARATION MOD INIT
----------------------------------------------------------------------------
oil_separation = {} --Establish "oil_separation" name space


----------------------------------------------------------------------------
--                           SETTINGS
----------------------------------------------------------------------------
--To change settings for the stains or the blight, see the respective scripts

--The "separation_time" variable controls how long before oil separates from paste.
--Used in two places in the "seed_paste_oily" node registration.
oil_separation.separation_time = 40 --Default (300)

--Chance that oily paste will not dry out after releasing oil near fire. Read as "1 out of fire_chance"
oil_separation.fire_chance = 2


----------------------------------------------------------------------------
--                      CHANGES TO FARMING MOD
----------------------------------------------------------------------------
--CHANGE HARVEST DROPS--
local crops = {
    {mod = "farming", name = "wheat", steps = 8},
    {mod = "farming", name = "cotton", steps = 8},
}

for i = 1, #crops do
    for j = 1, crops[i].steps do
        local node_name = crops[i].mod..":"..crops[i].name.."_"..j
        local harvest = crops[i].mod..":"..crops[i].name
        local seed = crops[i].mod..":seed_"..crops[i].name
        local drop = {}
        if j == crops[i].steps then
            drop = {
                items = {
                    {items = {seed}, rarity = 1},
                    {items = {harvest}, rarity = 1},
                    {items = {harvest}, rarity = 2},
                    --{items = {harvest}, rarity = 3},
                }
            }
        else
            drop = {
                items = {
                    {items = {seed}, rarity = 1},
                }
            }
        end

        minetest.override_item(node_name,{
            drop = drop,
        })
    end

    minetest.register_craft({
        type = "shapeless",
        output = crops[i].mod..":seed_"..crops[i].name,
        recipe = {crops[i].mod..":"..crops[i].name},
    })
end


----------------------------------------------------------------------------
--                           LOAD FILES
----------------------------------------------------------------------------
oil_separation.path = minetest.get_modpath("oil_separation")

dofile(oil_separation.path .. "/nodes.lua")
dofile(oil_separation.path .. "/abm.lua")
dofile(oil_separation.path .. "/blight.lua") --Comment out this line to remove blight