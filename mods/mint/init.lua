-- Copyright (C) AldoBr - GPLv2
-- Automatic selling machine and mint operation

-- Start the scheduler
modname = minetest.get_current_modname()
modpath = minetest.get_modpath(modname)
dofile(modpath .. '/scheduler.lua')

-- Denominators
-- Pence equals 1/9 shillings, 1/81 pounds or 1/729 of gold ingot
minetest.register_craftitem("mint:pences", {
	description = "Minetoon pence",
	inventory_image = "mint_goldcoin.png",
})
-- Shilling equals 1/9 pounds, 9 pence or 1/81 gold ingot
minetest.register_craftitem("mint:shillings", {
	description = "Minetoon shilling",
	inventory_image = "mint_9goldcoin.png",
})
-- Pound equals 1/9 gold ingot, 9 shilling or 81 pence)
minetest.register_craftitem("mint:pounds", {
	description = "Minetoon pounds",
	inventory_image = "mint_81goldcoin.png",
})
-- Gold ingot equals 729 pence, 81 shilling or 9 pounds

-- Transformations
-- Gold ingot to Pounds (1 to 9)
minetest.register_craft({
	type = "shapeless",
	output = '"mint:pounds" 9',
	recipe = { 'default:gold_ingot' }
})
-- Pounds to Gold ingot (9 to 1)
minetest.register_craft({
	type = "shapeless",
	output = '"default:gold_ingot" 1',
	recipe = { 
		"mint:pounds", "mint:pounds", "mint:pounds",
		"mint:pounds", "mint:pounds", "mint:pounds",
		"mint:pounds", "mint:pounds", "mint:pounds"
	}
})
-- Pounds to Shillings (1 to 9)
minetest.register_craft({
	type = "shapeless",
	output = '"mint:shillings" 9',
	recipe = { 'mint:pounds' }
})
-- Shilling to Pounds (9 to 1)
minetest.register_craft({
	type = "shapeless",
	output = 'mint:pounds',
	recipe = { 
		'mint:shillings', 'mint:shillings', 'mint:shillings', 
		'mint:shillings', 'mint:shillings', 'mint:shillings', 
		'mint:shillings', 'mint:shillings', 'mint:shillings'
	}
})
-- Shilling to Pence (1 to 9)
minetest.register_craft({
	type = "shapeless",
	output = '"mint:pences" 9',
	recipe = { 'mint:shillings' }
})
-- Pence to Shilling (9 to 1)
minetest.register_craft({
	type = "shapeless",
	output = '"mint:shillings" 1',
	recipe = {
		'mint:pences', 'mint:pences', 'mint:pences',
		'mint:pences', 'mint:pences', 'mint:pences',
		'mint:pences', 'mint:pences', 'mint:pences',
	}
})
local function soundalarm(pos)
	minetest.sound_play("mint_error", {pos=pos, gain=1.0, max_hear_distance=5 })
end

-- Used by asmoperate, abmoperate
local function soundok(pos)		
	minetest.sound_play("mint_coin", {pos=pos, gain=0.3, max_hear_distance=5})
end

-- Machine logic
mint = {

	-- Money accont data
	accounts = { },

	loadaccountsdatabase = function(machine)
		-- Load accounts database
		-- print("Loading bank accounts.")
		for line in io.lines(minetest.get_worldpath() .. "/accounts.dat") do
			local name, value = line:match("([^;]+);([^;]+)")
			-- print(name .. ';' .. tostring(value))
			machine.accounts[name] = tonumber(value)
		end
	end,
	
	saveaccountsdatabase = function(machine)
		-- Save accounts database
		-- print("Saving bank accounts.")
		local destination = io.open(minetest.get_worldpath() .. "/accounts.dat", "w")
		for name, value in pairs(machine.accounts) do
			-- print(name .. ';' .. value)
			destination:write(name .. ';' .. tostring(value) .. '\n')
		end
		io.close(destination)
	end,
	
	getaccountmoneytotal = function(machine, account)
		-- Get the ammount of money stored in the account account
		return machine.accounts[account]
	end,

	accountexists = function(machine, account)
		-- print(account .. ' ' .. tostring(machine.accounts[account]))
		-- for name, value in pairs(machine.accounts) do
		--   print(name .. ' -> ' .. value)
		-- end
		return machine.accounts[account] ~= nil
	end,
	
	deposittoaccount = function(machine, account, ammount)
		-- Deposits ammount to the account account
		machine.accounts[account] = machine.accounts[account] + ammount
	end,
	
	drawfromaccount = function(machine, account, ammount)
		-- Draws ammount from the account
		if machine.accounts[account] - ammount >= 0 then
			machine.accounts[account] = machine.accounts[account] - ammount
			return true
		else
			return false
		end
	end,
	
	createaccount = function(machine, account)
		-- Creates account
		machine.accounts[account] = 0
	end,

	-- Used by abmoperate, getinvcoincount
	getstackcount = function(machine, inv, name)
		-- will return the ammount of name in all stacks at inventary inv
		local h = 0
		local found = 0
		if not inv:is_empty("main") then
			for h = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", h)
				if stack:get_name() == name then
					if not stack:is_empty() then
						found = found + stack:get_count()
					end
				end
			end
		end
		return found
	end,

	-- Used by asmoperate
	getinvcoincount = function(machine, inv)
		-- will return the ammount of coins at inventory inv
		local coins = mint:getstackcount(inv, "mint:pences") + 
			mint:getstackcount(inv, "mint:shillings") * 9 + 
			mint:getstackcount(inv, "mint:pounds") * 81 +
			mint:getstackcount(inv, "default:gold_ingot") * 729
		-- print('you have '..coins..' coins.')
		return coins
	end,

	-- Used by clearcoins
	clearstacksof = function(machine, inv, name)
		-- will remove all stacks of name name in inventary inv
		local h = 0
		if not inv:is_empty("main") then
			for h = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", h)
				if stack:get_name() == name then
					-- minetest.debug('clearing a stack of '..name)
					inv:set_stack("main", h, ItemStack(""))
				end
			end
		end
	end,

	-- Used by asmoperate
	clearcoins = function(machine, inv)
		-- will remove all coins from the inventory inv
		mint:clearstacksof(inv, "mint:pences")
		mint:clearstacksof(inv, "mint:shillings")
		mint:clearstacksof(inv, "mint:pounds")
		mint:clearstacksof(inv, "default:gold_ingot")
	end,

	-- Used by asmoperate
	finditemthatisnotcoin = function(machine, inv)
		-- will find the name of the first item that is not a coin
		-- in the inventary inv
		local h = 0
		if not inv:is_empty("main") then
			-- minetest.debug("inv size : "..inv:get_size("main"))
			for h = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", h)
				if stack:get_name() ~= '' and 
					stack:get_name() ~= "mint:pences" and
					stack:get_name() ~= "mint:shillings" and
					stack:get_name() ~= "mint:pounds" and
					stack:get_name() ~= "default:gold_ingot" then
						return stack:get_name()
				end
			end
		end
		return ''
	end,
	findslotthatisnotcoin = function(machine, inv)
		-- will find the name of the first item that is not a coin
		-- in the inventary inv
		local h = 0
		if not inv:is_empty("main") then
			-- minetest.debug("inv size : "..inv:get_size("main"))
			for h = 1, inv:get_size("main") do
				local stack = inv:get_stack("main", h)
				if stack:get_name() ~= '' and 
					stack:get_name() ~= "mint:pences" and
					stack:get_name() ~= "mint:shillings" and
					stack:get_name() ~= "mint:pounds" and
					stack:get_name() ~= "default:gold_ingot" then
					return h
				end
			end
			
		end
		return ''
	end,
	-- Used by numberofslotsforcoins, addcoins
	coinammounttocoinstacks = function(machine, ammount)
		-- will return an array with the number of 99 stacks of each kind of coin, plus the remainers
		-- Transform into the largest denominators

		--print('<coin ammount to coin stacks.>')

		local lvalue = ammount
		--print('initial ammount '..lvalue)
		local goldingots = math.floor(lvalue / 729)
		--print('number of gold ingots '..goldingots)
		lvalue = math.floor(lvalue % 729)
		--print('remainer '..lvalue)
		local pounds = math.floor(lvalue / 81)
		--print('number of pounds '..pounds)
		lvalue = math.floor(lvalue % 81)
		--print('remainer '..lvalue)
		local shillings = math.floor(lvalue / 9)
		--print('number of shillings '..shillings)
		lvalue = math.floor(lvalue % 9)
		--print('remainer '..lvalue)
		local pences = math.floor(lvalue)
		--print('number of pences '..pences)
		-- Now transform into stacks
		local stackgoldingots = math.floor(goldingots / 99)
		--print('number of stacks of gold ingots '..stackgoldingots)
		local remgoldingots = math.floor(goldingots % 99)
		--print('remainer stack of gold ingot '..remgoldingots)
		local stackpounds = math.floor(pounds / 99)
		--print('number of stacks of pounds '..stackpounds)
		local rempounds = math.floor(pounds % 99)
		--print('remainer stack of pounds '..rempounds)
		local stackshillings = math.floor(shillings / 99)
		--print('number of stacks of shillings '..stackshillings)
		local remshillings = math.floor(shillings % 99)
		--print('remainer stack of shillings '..remshillings)
		local stackpences = math.floor(pences / 99)
		--print('number of stacks of pences '..stackpences)
		local rempences = math.floor(pences % 99)
		--print('remainer stack of pences '..rempences)
		
		-- Return the values
		return { 
				goldingot = stackgoldingots, 
				rgoldingot = remgoldingots, 
				pound = stackpounds, 
				rpound = rempounds, 
				shilling = stackshillings, 
				rshilling = remshillings, 
				pence = stackpences, 
				rpence = rempences 
			}
	end,

	-- Used by asmoperate
	addcoins = function(machine, inv, ammount)
		-- will add the ammount ammount of coins to the inventory inv,
		-- respecting the 99 item limit for stacks
		local stacks = mint:coinammounttocoinstacks(ammount)
		local i = 0
		-- Gold ingots
		if stacks.goldingot > 0 then
			for i=1, stacks.goldingot do
				inv:add_item("main", "default:gold_ingot 99")
			end
		end
		if stacks.rgoldingot > 0 then
			inv:add_item("main", "default:gold_ingot "..stacks.rgoldingot)
		end
		-- Pounds
		if stacks.pound > 0 then
			for i=1, stacks.pound do
				inv:add_item("main", "mint:pounds 99")
			end
		end
		if stacks.rpound > 0 then
			inv:add_item("main", "mint:pounds "..stacks.rpound)
		end
		-- Shillings
		if stacks.shilling > 0 then
			for i=1, stacks.shilling do
				inv:add_item("main", "mint:shillings 99")
			end
		end
		if stacks.rshilling > 0 then
			inv:add_item("main", "mint:shillings "..stacks.rshilling)
		end
		-- Pence
		if stacks.pence > 0 then
			for i=1, stacks.pence do
				inv:add_item("main", "mint:pences 99")
			end
		end
		if stacks.rpence > 0 then
			inv:add_item("main", "mint:pences "..stacks.rpence)
		end
	end,

	-- Used by asmoperate
	numberofslotsforcoins = function(machine, ammount)
		-- will return the number of free slots needed to store ammount of coins
		local stacks = mint:coinammounttocoinstacks(ammount)
		dump(stacks)
		-- stacks
		local result = 
			stacks.goldingot + 
			stacks.pound + 
			stacks.shilling + 
			stacks.pence
		-- remainers
		if stacks.rgoldingot > 0 then
			result = result + 1
		end
		if stacks.rpound > 0 then
			result = result + 1
		end
		if stacks.rshilling > 0 then
			result = result + 1
		end
		if stacks.rpence > 0 then
			result = result + 1
		end
		return result
	end,

	-- Used by asmoperate
	numberofitemslots = function(machine, inv)
		-- will return the number of slots in inventory inv 
		-- that are used to store items not related to coins
		local h = 0
		local count = 0
		for h = 1, inv:get_size("main") do
			local stack = inv:get_stack("main", h)
			if stack:is_empty() or 
				stack:get_name() == "default:gold_ingot" or
				stack:get_name() == "mint:pounds" or
				stack:get_name() == "mint:shillings" or
				stack:get_name() == "mint:pences" then
				count = count + 1
			end
		end
		return inv:get_size("main") - count
	end,
	
	-- Used by asmoperate, abmoperate
	
	-- Used by asmoperate
	registersell = function(machine, item, value)
		-- TODO: Implement database
	end,
	
	-- Used by abmoperate
	registerbuy = function(machine, item, value)
		-- TODO: Implement database
	end,

	asmoperate = function(machine, pos, puncher)

		-- Will operate an ASM machine at position pos by player puncher

		-- Meta information for the machine
		local meta = minetest.env:get_meta(pos)
		-- Get player inventory
		local playerinv = puncher:get_inventory()
		-- Get local inventory
		local localinv = meta:get_inventory()
		-- Get price of item
		local price = tonumber(meta:get_string("price"))
		-- If the price was not set, assume its 1
		if price == nil or price < 0 then
			price = 1
		end
		-- Get the item to be sold
		local itemsold = mint:finditemthatisnotcoin(localinv)

		-- Monetary
		-- Calculate the ammount of coins that the player have
		local playercoins = mint:getinvcoincount(playerinv)
		-- print('player have '..playercoins..' coins.')
		-- Calculate the ammount of coins that the machine have
		local localcoins = mint:getinvcoincount(localinv)
		-- print('machine have '..localcoins..' coins.')
		-- print('total coins in the transaction '..playercoins+localcoins)
		-- Calculate the end result ammount of coins for the player
		local endplayercoins = playercoins - price
		-- print('player should have '..endplayercoins..' coins.')
		-- Calculate the end result ammount of coins for the machine
		local endlocalcoins = localcoins + price
		-- print('machine should have '..endlocalcoins..' coins.')
		
		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in machine inventory that are not coin related
		local localitems = mint:numberofitemslots(localinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercoins)
		-- Get the number of slots in machine inventory that are needed to store the coins
		local localcoinslots = mint:numberofslotsforcoins(endlocalcoins)
		-- Get the number of slots that are needed to store existing player items, resulting player coins and plus one for the sold item
		local playertotalslots = playeritems + playercoinslots + 1
		-- Get the number of slots that are needed to store existing machine items, and resulting machine coins
		local localtotalslots = localitems + localcoinslots
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of slots that the machine have in inventory
		local localslots = localinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots
		-- Get the total number of free slots after the whole transaction in machine inventory
		local localendfreeslots = localslots - localtotalslots

		-- Transaction checks
		-- Check to see if the player inventory will overflow
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Check to see if the machine inventory will overflow
		if localendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in machine inventory.")
			return
		end
		-- Return if there is nothing to sell
		if itemsold == "" then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: No item to sell.")
			return
		end
		-- Return if the player end ammount of coins is negative (he does not have enough money to buy)
		if endplayercoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end
		--This Stops players from selling used tools
		local h = 0
		
		for h = 1, localinv:get_size("main") do
			local item = localinv:get_stack("main", h)
			if item:get_wear() > 0 then
			
				soundalarm(pos)
				minetest.chat_send_player(puncher:get_player_name(), "Error: Can't sell used tools.")
				return
			end
		end
		
		
		-- Operation
		-- Add item to the player inventory
		playerinv:add_item("main", itemsold.." 1")
		-- Remove item from the machine inventary
		localinv:remove_item("main", itemsold..' 1')
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Remove all coins from the machine
		mint:clearcoins(localinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercoins)
		-- Put the price paid back to the machine
		mint:addcoins(localinv, endlocalcoins)
		-- Sound ok
		soundok(pos)
		-- Register sell
		mint:registersell(itemsold, price)
		
	end,
	masmoperate = function(machine, pos, puncher)

		-- Will operate an ASM machine at position pos by player puncher

		-- Meta information for the machine
		local meta = minetest.env:get_meta(pos)
		-- Get player inventory
		local playerinv = puncher:get_inventory()
		-- Get local inventory
		local localinv = meta:get_inventory()
		-- Get price of item
		local price = tonumber(meta:get_string("price"))
		-- If the price was not set, assume its 1
		if price == nil or price < 0 then
			price = 1
		end
		-- Get the item to be sold
		local itemsold = mint:findslotthatisnotcoin(localinv)

		-- Monetary
		-- Calculate the ammount of coins that the player have
		local playercoins = mint:getinvcoincount(playerinv)
		-- print('player have '..playercoins..' coins.')
		-- Calculate the ammount of coins that the machine have
		local localcoins = mint:getinvcoincount(localinv)
		-- print('machine have '..localcoins..' coins.')
		-- print('total coins in the transaction '..playercoins+localcoins)
		-- Calculate the end result ammount of coins for the player
		local endplayercoins = playercoins - price
		-- print('player should have '..endplayercoins..' coins.')
		-- Calculate the end result ammount of coins for the machine
		local endlocalcoins = localcoins + price
		-- print('machine should have '..endlocalcoins..' coins.')
		
		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in machine inventory that are not coin related
		local localitems = mint:numberofitemslots(localinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercoins)
		-- Get the number of slots in machine inventory that are needed to store the coins
		local localcoinslots = mint:numberofslotsforcoins(endlocalcoins)
		-- Get the number of slots that are needed to store existing player items, resulting player coins and plus one for the sold item
		local playertotalslots = playeritems + playercoinslots + 1
		-- Get the number of slots that are needed to store existing machine items, and resulting machine coins
		local localtotalslots = localitems + localcoinslots
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of slots that the machine have in inventory
		local localslots = localinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots
		-- Get the total number of free slots after the whole transaction in machine inventory
		local localendfreeslots = localslots - localtotalslots
		
		-- Transaction checks
		-- Check to see if the player inventory will overflow
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Check to see if the machine inventory will overflow
		if localendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in machine inventory.")
			return
		end
		-- Return if there is nothing to sell
		if itemsold == "" then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: No item to sell.")
			return
		end
		local item = localinv:get_stack("main", itemsold)
		local found = 0
		if not item:is_empty() then
			found = found + item:get_count()
		end
		endplayercoins = playercoins - (price * found)
		-- Return if the player end ammount of coins is negative (he does not have enough money to buy)
		if endplayercoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end
		--This Stops players from selling used tools
		
		
		

		
		local posAbove = {x = pos.x, y = pos.y + 1, z = pos.z}
		minetest.add_item(posAbove, item)
		localinv:set_stack("main", itemsold, ItemStack(""))

		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Remove all coins from the machine
		mint:clearcoins(localinv)
		-- Return the change for the player
		
		mint:addcoins(playerinv, endplayercoins)
		endlocalcoins = localcoins + (price * found)
		-- Put the price paid back to the machine
		mint:addcoins(localinv, endlocalcoins)
		-- Sound ok
		soundok(pos)
		print(minetest.pos_to_string(pos))
		-- Register sell
		mint:registersell(itemsold, (price * found))
		
	end,
	
	-- JOSIAH's CODE
	aboperate = function(machine, pos, puncher)

		-- Will operate an AB machine at position pos by player puncher

		-- Meta information for the machine
		local meta = minetest.env:get_meta(pos)
		-- Get player inventory
		local playerinv = puncher:get_inventory()
		-- Get local inventory
		local localinv = meta:get_inventory()
		-- Get mint
		local price = tonumber(meta:get_string("price"))
		-- If the mint was not set, assume its 1
		if price == nil or price < 0 then
			price = 1
		end
		

		-- Monetary
		-- Calculate the ammount of coins that the player have
		local playercoins = mint:getinvcoincount(playerinv)
		-- print('player have '..playercoins..' coins.')
		-- Calculate the ammount of coins that the machine have
		local localcoins = mint:getinvcoincount(localinv)
		-- print('machine have '..localcoins..' coins.')
		-- print('total coins in the transaction '..playercoins+localcoins)
		-- Calculate the end result ammount of coins for the player
		local endplayercoins = playercoins - price
		-- print('player should have '..endplayercoins..' coins.')
		-- Calculate the end result ammount of coins for the machine
		local endlocalcoins = localcoins + price
		-- print('machine should have '..endlocalcoins..' coins.')
		
		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in machine inventory that are not coin related
		local localitems = mint:numberofitemslots(localinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercoins)
		-- Get the number of slots in machine inventory that are needed to store the coins
		local localcoinslots = mint:numberofslotsforcoins(endlocalcoins)
		-- Get the number of slots that are needed to store existing player items, resulting player coins and plus one for the sold item
		local playertotalslots = playeritems + playercoinslots + 1
		-- Get the number of slots that are needed to store existing machine items, and resulting machine coins
		local localtotalslots = localitems + localcoinslots
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of slots that the machine have in inventory
		local localslots = localinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots
		-- Get the total number of free slots after the whole transaction in machine inventory
		local localendfreeslots = localslots - localtotalslots

		-- Transaction checks
		-- Check to see if the player inventory will overflow
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Check to see if the machine inventory will overflow
		if localendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in machine inventory.")
			return
		end
		
		
		-- Return if the player end ammount of coins is negative (he does not have enough money to buy)
		if endplayercoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end

		-- Operation
		
		
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Remove all coins from the machine
		mint:clearcoins(localinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercoins)
		-- Put the price paid back to the machine
		mint:addcoins(localinv, endlocalcoins)
		-- Sound ok
		soundok(pos)
		-- Register sell
		mint:registersell(itemsold, price)
		
	end,--end of JOSIAH code
	mabmoperate = function(machine, pos, puncher)

		-- will operate an ABM machine at position pos by player puncher

		-- Meta information for the machine
		local meta = minetest.env:get_meta(pos)
		-- Get player inventory
		local playerinv = puncher:get_inventory()
		-- Get local inventory
		local localinv = meta:get_inventory()
		-- Get price of item
		local price = tonumber(meta:get_string("price"))
		-- If the price was not set, assume its 1
		if price == nil or price < 0 then
			price = 1
		end
		-- Get the item to be sold
		local itemsold = meta:get_string("item")

		-- Monetary
		-- Calculate the ammount of coins that the player have
		local playercoins = mint:getinvcoincount(playerinv)
		-- print('player have '..playercoins..' coins.')
		-- Calculate the ammount of coins that the machine have
		local localcoins = mint:getinvcoincount(localinv)
		-- print('machine have '..localcoins..' coins.')
		-- print('total coins in the transaction '..playercoins+localcoins)
		-- Calculate the end result ammount of coins for the player
		local endplayercoins = playercoins + (price * 99)
		-- print('player should have '..endplayercoins..' coins.')
		-- Calculate the end result ammount of coins for the machine
		local endlocalcoins = localcoins - (price * 99)
		-- print('machine should have '..endlocalcoins..' coins.')

		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in machine inventory that are not coin related
		local localitems = mint:numberofitemslots(localinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercoins)
		-- Get the number of slots in machine inventory that are needed to store the coins
		local localcoinslots = mint:numberofslotsforcoins(endlocalcoins)
		-- Get the number of slots that are needed to store existing player items and resulting player coins 
		local playertotalslots = playeritems + playercoinslots
		-- Get the number of slots that are needed to store existing machine items, resulting machine coins and plus one for the bought item
		local localtotalslots = localitems + localcoinslots + 1
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of slots that the machine have in inventory
		local localslots = localinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots
		-- Get the total number of free slots after the whole transaction in machine inventory
		local localendfreeslots = localslots - localtotalslots

		-- Transaction checks
		-- Check to see if the player inventory will overflow
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Check to see if the machine inventory will overflow
		if localendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in machine inventory.")
			return
		end
		-- Return if there is nothing to sell
		if itemsold == "" then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Machine has no item configured to sell.")
			return
		end
		-- Return if the machine end ammount of coins is negative (it does not have enough money to buy)
		if endlocalcoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end
		-- Check if the player has the item to sell
		if mint:getstackcount(playerinv, itemsold) <= 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Player doesn't have the item that this machine buys.")
			return
		end
		--This Stops players from selling used tools
		local h = 0
		for h = 1, playerinv:get_size("main") do
			local item = playerinv:get_stack("main", h)
			if item:get_wear() > 0 then
				if item:get_name() == itemsold then
					soundalarm(pos)
					minetest.chat_send_player(puncher:get_player_name(), "Error: Can't Buy when used ".. itemsold .." is in invetory")
					return
				end
				
			end
		end
	
		local toltNumberOfItemsThatPlayerHas = mint:getstackcount(playerinv, itemsold)
		if toltNumberOfItemsThatPlayerHas ~= nil then
			if toltNumberOfItemsThatPlayerHas < 99 then
				soundalarm(pos)
				minetest.chat_send_player(puncher:get_player_name(), "Error: Not Enough ".. itemsold .." in invetory")
				return
			end
		else
			return
		end
		-- Return if the player end ammount of coins is negative (he does not have enough money to buy)
		if endlocalcoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end
		-- Operation
		-- Remove item from the player inventary
		playerinv:remove_item("main", itemsold..' 99') --change 99 to the max stack number
		-- Add item to the machine inventory
		localinv:add_item("main", itemsold.." 99") --change 99 to the max stack number
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Remove all coins from the machine
		mint:clearcoins(localinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercoins)
		-- Put the price paid back to the machine
		mint:addcoins(localinv, endlocalcoins)
		-- Sound ok
		soundok(pos)
		-- Register the buy
		mint:registerbuy(itemsold, price)

	end,
	abmoperate = function(machine, pos, puncher)

		-- will operate an ABM machine at position pos by player puncher

		-- Meta information for the machine
		local meta = minetest.env:get_meta(pos)
		-- Get player inventory
		local playerinv = puncher:get_inventory()
		-- Get local inventory
		local localinv = meta:get_inventory()
		-- Get price of item
		local price = tonumber(meta:get_string("price"))
		-- If the price was not set, assume its 1
		if price == nil or price < 0 then
			price = 1
		end
		-- Get the item to be sold
		local itemsold = meta:get_string("item")

		-- Monetary
		-- Calculate the ammount of coins that the player have
		local playercoins = mint:getinvcoincount(playerinv)
		-- print('player have '..playercoins..' coins.')
		-- Calculate the ammount of coins that the machine have
		local localcoins = mint:getinvcoincount(localinv)
		-- print('machine have '..localcoins..' coins.')
		-- print('total coins in the transaction '..playercoins+localcoins)
		-- Calculate the end result ammount of coins for the player
		local endplayercoins = playercoins + price
		-- print('player should have '..endplayercoins..' coins.')
		-- Calculate the end result ammount of coins for the machine
		local endlocalcoins = localcoins - price
		-- print('machine should have '..endlocalcoins..' coins.')

		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in machine inventory that are not coin related
		local localitems = mint:numberofitemslots(localinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercoins)
		-- Get the number of slots in machine inventory that are needed to store the coins
		local localcoinslots = mint:numberofslotsforcoins(endlocalcoins)
		-- Get the number of slots that are needed to store existing player items and resulting player coins 
		local playertotalslots = playeritems + playercoinslots
		-- Get the number of slots that are needed to store existing machine items, resulting machine coins and plus one for the bought item
		local localtotalslots = localitems + localcoinslots + 1
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of slots that the machine have in inventory
		local localslots = localinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots
		-- Get the total number of free slots after the whole transaction in machine inventory
		local localendfreeslots = localslots - localtotalslots

		-- Transaction checks
		-- Check to see if the player inventory will overflow
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Check to see if the machine inventory will overflow
		if localendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in machine inventory.")
			return
		end
		-- Return if there is nothing to sell
		if itemsold == "" then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Machine has no item configured to sell.")
			return
		end
		-- Return if the machine end ammount of coins is negative (it does not have enough money to buy)
		if endlocalcoins < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money.")
			return
		end
		-- Check if the player has the item to sell
		if mint:getstackcount(playerinv, itemsold) <= 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Player doesn't have the item that this machine buys.")
			return
		end
		--This Stops players from selling used tools
		local h = 0
		
		--minetest.chat_send_player(puncher:get_player_name(), stackNum)
		for h = 1, playerinv:get_size("main") do
			local item = playerinv:get_stack("main", h)
			if item:get_wear() > 0 then
				if item:get_name() == itemsold then
					soundalarm(pos)
					minetest.chat_send_player(puncher:get_player_name(), "Error: Can't Buy when used ".. itemsold .." is in invetory")
					return
				end
				
			end
		end
		-- Operation
		-- Remove item from the player inventary
		playerinv:remove_item("main", itemsold..' 1')
		-- Add item to the machine inventory
		localinv:add_item("main", itemsold.." 1")
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Remove all coins from the machine
		mint:clearcoins(localinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercoins)
		-- Put the price paid back to the machine
		mint:addcoins(localinv, endlocalcoins)
		-- Sound ok
		soundok(pos)
		-- Register the buy
		mint:registerbuy(itemsold, price)

	end,
	
	drawoperate = function(machine, pos, puncher)
		-- Operates the money drawing machine
		
		-- Default ammount of coins
		local drawconst = 1

		-- Get player inventory
		local playerinv = puncher:get_inventory()

		-- Checks if player account exists
		local player = puncher:get_player_name()
		if not mint:accountexists(player) then
			mint:createaccount(player)
		end
		
		-- Accounting
		-- Calc player inventory value
		local playercash = mint:getinvcoincount(playerinv)
		-- Get player account value
		local playeraccount = mint:getaccountmoneytotal(player)
			-- Calc ammount of cash to deposit
		if playeraccount >= 729 then
			drawconst = 729
		elseif playeraccount >= 81 then
			drawconst = 81
		elseif playeraccount >= 9 then
			drawconst = 9
		else 
			drawconst = 1
		end
		-- Calc the ammount of cash in player hands after operation
		local endplayercash = playercash + drawconst
		-- Calc the ammount of cash in player account after operation
		local endplayeraccount = playeraccount - drawconst

		-- Space
		-- Get the number of slots in player inventory that are not coin related
		local playeritems = mint:numberofitemslots(playerinv)
		-- Get the number of slots in player inventory that are needed to store the coins
		local playercoinslots = mint:numberofslotsforcoins(endplayercash)
		-- Get the number of slots that are needed to store existing player items and resulting player coins 
		local playertotalslots = playeritems + playercoinslots + 1
		-- Get the total number of slots that the player have in inventory
		local playerslots = playerinv:get_size("main")
		-- Get the total number of free slots after the whole transaction in player inventory
		local playerendfreeslots = playerslots - playertotalslots

		-- Transaction checks
		-- Return if player has no free slots
		if playerendfreeslots < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough slots in player inventory.")
			return
		end
		-- Return if player account would end negative
		if endplayeraccount < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money in account.")
			return
		end

		-- Operation
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercash)
		-- Save current acount status
		mint:drawfromaccount(player, drawconst)
		-- Sound ok
		soundok(pos)

	end,
	
	depositoperate = function(machine, pos, puncher)
		-- Operates the money deposit machine

		-- Default ammount of coins
		local drawconst = 1

		-- Get player inventory
		local playerinv = puncher:get_inventory()

		-- Checks if player account exists
		local player = puncher:get_player_name()
		if not mint:accountexists(player) then
			mint:createaccount(player)
		end
		
		-- Accounting
		-- Calc player inventory value
		local playercash = mint:getinvcoincount(playerinv)
		-- Get player account value
		local playeraccount = mint:getaccountmoneytotal(player)
		-- Calc ammount of cash to deposit
		if playercash >= 729 then
			drawconst = 729
		elseif playercash >= 81 then
			drawconst = 81
		elseif playercash >= 9 then
			drawconst = 9
		else 
			drawconst = 1
		end
		-- Calc the ammount of cash in player hands after operation
		local endplayercash = playercash - drawconst
		-- Calc the ammount of cash in player account after operation
		local endplayeraccount = playeraccount + drawconst

		-- Transaction checks
		-- Return if player cash would end negative
		if endplayercash < 0 then
			-- Sound the alarm and quit
			soundalarm(pos)
			minetest.chat_send_player(puncher:get_player_name(), "Error: Not enough money in hands.")
			return
		end

		-- Operation
		-- Remove all coins from the player
		mint:clearcoins(playerinv)
		-- Return the change for the player
		mint:addcoins(playerinv, endplayercash)
		-- Save current acount status
		mint:deposittoaccount(player, drawconst)
		-- Sound ok
		soundok(pos)

	end

}
--admission functions

minetest.register_node("mint:admission_box", {
	tiles = {
		"PayHereTop.png",
		"PayHereTop.png",
		"PayHere.png",
		"PayHere.png",
		"PayHere.png",
		"PayHere.png"
	},
	
	description = "admission Box",
	walkable = true,
	paramtype = "light",
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	
	--machine functions
	
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("price", '1')
		meta:set_string("infotext", "mint costs " .. meta:get_string("price") .. " pence.")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
				meta:set_string("infotext", "mint costs " .. meta:get_string("price") .. " pence.")
			end
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"label[6,9;Press TAB to edit price]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "mint unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked AB belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked AB belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a AB belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in AB at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to AB at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from AB at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:aboperate(pos, puncher)
	end
})

-- Automatic Selling Machine
minetest.register_node("mint:asm", {
	description = "Automatic Selling Machine",
	tiles = {
		"default_chest_top2.png",
		"default_chest_top2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"mint_sale.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("price", '1')
		meta:set_string("infotext", "This machine sells items for " .. meta:get_string("price") .. " pence.")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
				meta:set_string("infotext", "This machine sells items for " .. meta:get_string("price") .. " pence.")
			end
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"label[6,9;Press TAB to edit price]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "Price unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in ASM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to ASM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from ASM at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:asmoperate(pos, puncher)
	end
})

minetest.register_node("mint:masm", {
	description = "Automatic Bulk Selling Machine",
	tiles = {
		"default_chest_top2.png",
		"default_chest_top2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"mint_MasSeller.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("price", '1')
		meta:set_string("infotext", "This machine sells an item for " .. meta:get_string("price") .. " pence.")
		
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
				meta:set_string("infotext", "This machine sells items for " .. meta:get_string("price") .. " pence per item.")
			end
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"label[6,9;Press TAB to edit price]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "Price unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a ASM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in ASM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to ASM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from ASM at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:masmoperate(pos, puncher)
	end
})
-- Automatic Buying Machine
minetest.register_node("mint:abm", {
	description = "Automatic Buying Machine",
	tiles = {
		"default_chest_top2.png",
		"default_chest_top2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"mint_buy.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Price " .. meta:get_string("price") .. " pence.")
		meta:set_string("item", "default:dirt")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
			end
			if fields["item"] ~= nil then
				meta:set_string("item", fields["item"])
			end
			meta:set_string("infotext", "This machine buys "..meta:get_string("item")..
				" for " .. meta:get_string("price") .. " pence.")
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"field[0.5,11;3,1;item;item;${item}]"..
				"label[6,9;Press TAB to edit price and item]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "Price unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		meta:set_string("item", "deafult:dirt")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos, player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from ABM at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:abmoperate(pos, puncher)
	end
})
minetest.register_node("mint:mabm", {
	description = "Automatic Bulk Buying Machine",
	tiles = {
		"default_chest_top2.png",
		"default_chest_top2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"mint_MasBuyer.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Price " .. meta:get_string("price") .. " pence.")
		meta:set_string("item", "default:dirt")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
			end
			if fields["item"] ~= nil then
				meta:set_string("item", fields["item"])
			end

			local price = (tonumber(meta:get_string("price"))) --change 99 to the max stack number
			local tolalPrice = tonumber(price*99)
			meta:set_string("infotext", "This machine buys a stack of 99 "..meta:get_string("item").. --change 99 to the max stack number
				" at " .. price .. " pence per unit, for a tolal of " .. tolalPrice .. " pence per stack.") 
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"field[0.5,11;3,1;item;item;${item}]"..
				"label[6,9;Press TAB to edit price and item]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "Price unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		meta:set_string("item", "deafult:dirt")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos, player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from ABM at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:mabmoperate(pos, puncher)
	end
})
-- Automatic Buying Machine
minetest.register_node("mint:abm", {
	description = "Automatic Buying Machine",
	tiles = {
		"default_chest_top2.png",
		"default_chest_top2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"default_chest_side2.png",
		"mint_buy.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Price " .. meta:get_string("price") .. " pence.")
		meta:set_string("item", "default:dirt")
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		if sender:get_player_name() == meta:get_string("owner") then
			if tonumber(fields["price"]) ~= nil then
				meta:set_string("price", fields["price"])
			end
			if fields["item"] ~= nil then
				meta:set_string("item", fields["item"])
			end
			meta:set_string("infotext", "This machine buys "..meta:get_string("item")..
				" for " .. meta:get_string("price") .. " pence.")
		end
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", 
				"invsize[10,12;]"..
				"list[current_name;main;0,0;10,4;]"..
				"list[current_player;main;0,5;8,4;]"..
				"field[0.5,10;3,1;price;price;${price}]"..
				"field[0.5,11;3,1;item;item;${item}]"..
				"label[6,9;Press TAB to edit price and item]"..
				"label[6,10;Close by pressing ENTER]"
			)
		meta:set_string("infotext", "Price unset.")
		meta:set_string("owner", "")
		meta:set_string("price", "1")
		meta:set_string("item", "deafult:dirt")
		local inv = meta:get_inventory()
		inv:set_size("main", 10*4)
	end,
	can_dig = function(pos, player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
  allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a locked ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
  allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if player:get_player_name() ~= meta:get_string("owner") then
			minetest.log("action", player:get_player_name()..
			" tried to access a ABM belonging to "..
			meta:get_string("owner").." at "..
			minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff in ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" moves stuff to ABM at "..minetest.pos_to_string(pos))
	end,
  on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
		" takes stuff from ABM at "..minetest.pos_to_string(pos))
	end,
	on_punch = function(pos, node, puncher)
		mint:abmoperate(pos, puncher)
	end
})

-- Drawing Machine
minetest.register_node("mint:draw", {
	description = "Money drawing machine",
	tiles = {
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"mint_draw.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Punch this machine to draw money from your bank account.")
	end,
	on_punch = function(pos, node, puncher)
		mint:drawoperate(pos, puncher)
	end
})

-- Deposit machine
minetest.register_node("mint:deposit", {
	description = "Money depositing machine",
	tiles = {
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"default_steel_block.png",
		"mint_put.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	walkable = true,
	light_source = 10,
	groups = { oddly_breakable_by_hand=2 },
	sounds = {
		footsteps = { },
		dig = { },
		dug = { }
	},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("infotext", "Punch this machine to deposit money into your bank account.")
	end,
	on_punch = function(pos, node, puncher)
		mint:depositoperate(pos, puncher)
	end
})
minetest.register_craft({
	
		output = 'mint:admission_box',
		recipe = {
		
		{'group:wood','default:steel_ingot','group:wood'},		
		{'group:wood','default:steel_ingot','default:steel_ingot'},
		{'group:wood','default:steel_ingot','group:wood'},

		}
})	

-- Crafting recipes
-- ASM
minetest.register_craft({
	output = '"mint:asm" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:wood", "default:wood", "default:wood" }
	}
})

-- ABM
minetest.register_craft({
	output = '"mint:abm" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:wood", "default:steel_ingot", "default:wood" }
	}
})

minetest.register_craft({
	output = '"mint:masm" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:copper_ingot", "default:copper_ingot", "default:copper_ingot" },
		{ "default:wood", "default:wood", "default:wood" }
	}
})

-- ABM
minetest.register_craft({
	output = '"mint:mabm" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:copper_ingot", "default:copper_ingot", "default:copper_ingot" },
		{ "default:wood", "default:copper_ingot", "default:wood" }
	}
})

-- Drawing machine
minetest.register_craft({
	output = '"mint:draw" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:steel_ingot", "default:steel_ingot", "default:wood" }
	}
})

-- Deposit machine
minetest.register_craft({
	output = '"mint:deposit" 1',
	recipe = { 
		{ "default:wood", "default:wood", "default:wood" },
		{ "default:steel_ingot", "default:steel_ingot", "default:steel_ingot" },
		{ "default:wood", "default:steel_ingot", "default:steel_ingot" }
	}
})

-- Create account for player upon he entering the server
mintonjoinplayer = function(player)
	local account = player:get_player_name()
	-- Hack for single player
	if not mint:accountexists(account) then
		print("creating account for player "..account)
		mint:createaccount(account)
	end
end
minetest.register_on_joinplayer(mintonjoinplayer)

-- Autosave bank accounts every 5 minutes
mintautosave = function()
	mint:saveaccountsdatabase()
  -- use the new scheduler
	-- dont use local scheduler
	-- minetest.after(5 * 60, mintautosave)
end

-- Load bank accounts data on startup
mintonstartup = function()
	mint:loadaccountsdatabase()
	-- use the new scheduler
	defaultscheduler:createevent('Mint autosave', 'server', 0, -1, 5, mintautosave)
	-- use local scheduler
	-- minetest.after(5 * 60, mintautosave)
end
mintonstartup()

-- Save bank accounts data on shutdown
mintonshutdown = function()
	mint:saveaccountsdatabase()
end
minetest.register_on_shutdown(mintonshutdown)

-- Simple command to show your bank standing
minetest.register_chatcommand("bank", {
	params = "none",
	description = "Shows your's current bank balance",
	func = function(name, param)
		if mint:accountexists(name) then
			minetest.chat_send_player(name, "Your current bank balance: " .. mint:getaccountmoneytotal(name))		
			return true, "Done."
		else
			minetest.chat_send_player(name, "Strangely, you dont curretly own a bank account with us.")		
			return false, "Not done."
		end
	end,
})

-- Command to create a recurrent payment
minetest.register_chatcommand("transfer", {
	params = "<toaccount> <ammount> <repeating> <interval>",
	description = "Programmed money transfer",
	func = function(name, param)
		toaccount, ammount, repeating, interval = string.match(param, "([^ ]+) ([0-9]+) (-?[0-9]+) ([0-9]+)")
		if not mint:accountexists(name) then
			minetest.chat_send_player(name, "You do not curretly own a bank account with us.")		
			return false, "Not done."
		end
		if toaccount == nil or ammount == nil or repeating == nil or interval == nil then
			minetest.chat_send_player(name, "Wrong parameters.")
			minetest.chat_send_player(name, "Usage :")
			minetest.chat_send_player(name, "transfer <toaccount> <ammount> <repeating> <interval>")
			minetest.chat_send_player(name, "Where :")
			minetest.chat_send_player(name, "<toaccount> is the nickname of the player wich should receive the payment")
			minetest.chat_send_player(name, "<ammount> is the ammont of pences to transfer")
			minetest.chat_send_player(name, "<repeating> is the number of times the transfer should happen (use -1 for a neverending transfer)")
			minetest.chat_send_player(name, "<interval> is the number of server time ticks between each transfer")
			return false, "Not done."
		end
		if not mint:accountexists(toaccount) then
			minetest.chat_send_player(name, "Target account does not exist.")
			return false, "Not done."
		end
		transferid = defaultscheduler:createevent(name, "Money transfer from " .. name .. " to " .. toaccount, defaultscheduler.timerticks + interval, repeating, interval, 
			function()
				local canTransfer = mint:drawfromaccount(name, ammount)
				if canTransfer then
					mint:deposittoaccount(toaccount, ammount)
				end
			end
		)
		--minetest.chat_send_player(name, "Transfer id : " .. transferid)
		return true, "Done."
	end,
})

-- Command to delete a recurrent payment
minetest.register_chatcommand("deletetransfer", {
	params = "<id>",
	description = "Delete a programmed money transfer",
	func = function(name, param)
		id = string.match(param, "([0-9]+)")
		if not mint:accountexists(name) then
			minetest.chat_send_player(name, "You do not curretly own a bank account with us.")		
			return false, "Not done."
		end
		if id == nil then
			minetest.chat_send_player(name, "Wrong parameters.")
			minetest.chat_send_player(name, "Usage :")
			minetest.chat_send_player(name, "deletetransfer <transferid>")
			minetest.chat_send_player(name, "Where :")
			minetest.chat_send_player(name, "<transferid> is the id of the transfer to be deleted")
			return false, "Not done."
		end
		defaultscheduler:deleveeventbyuser(name, tonumber(id))
		return true, "Done."
	end,
})

-- Command to list all recurrent payments
minetest.register_chatcommand("listtransfers", {
	params = "none",
	description = "lists all transfers programmed by the user",
	func = function(name, param)
		if not mint:accountexists(name) then
			minetest.chat_send_player(name, "You do not curretly own a bank account with us.")		
			return false, "Not done."
		end
		transfers = defaultscheduler:listevents(name)
		minetest.chat_send_player(name, "Programmed money transfers:")
		for n, value in pairs(transfers) do
			minetest.chat_send_player(name, "ID: " .. n .. ", Type: " .. value.eventname .. ", outstanding payments: " .. value.eventrepeat .. ", interval " .. value.eventinterval)
		end
		return true, "Done."
	end,
})
