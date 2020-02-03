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
                    {items = {seed}, rarity = 1},    --100%
                    {items = {harvest}, rarity = 1}, --100%
                    {items = {harvest}, rarity = 2}, -- 50%
                    {items = {harvest}, rarity = 3}, -- 33%
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