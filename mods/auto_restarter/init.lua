
timeBetweenRestart = tonumber(minetest.setting_get("restarting_interval")) or 43200-- 12 hours 

lastwetherTime = minetest.get_gametime()

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer + dtime
	
	if timeBetweenRestart - 120 <= timer and timeBetweenRestart - 119.1 >= timer then	
		minetest.chat_send_all("*** Server Restarting in 2 Minutes ***")
	end
	
	if timeBetweenRestart <= timer then
		core.request_shutdown("", core.is_yes(true), 0)
	end
end)
