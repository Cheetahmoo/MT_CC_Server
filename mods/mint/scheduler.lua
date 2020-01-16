-- Copyright (C) AldoBr - GPLv2
-- Usefull routines for scheduling repetitive tasks

-- Scheduler object
function createscheduler()
	return {

		-- Number of ticks since game started
		timerticks = 0,

		-- Table containning the events
		events = { },

		-- Last Id used
		lastschedulerentryid = 0,

		-- Get a new ID for the event	
		createnewschedulerentryid = function(pThis)
			pThis.lastschedulerentryid = pThis.lastschedulerentryid + 1
			return pThis.lastschedulerentryid
		end,

		-- Scheduler entry object
		-- pTime is the time that the event will take place first (in number of timer ticks since server started)
		-- pRepeatTimes is the number of times the event should be repeated (-1 to repeat indefinitely)
		-- pRepeatInterval is the interval in timer ticks between each repetition 
		-- pFunction is the function that should be called when the event takes place
		createevent = function(pThis, pUser, pName, pTime, pRepeatTimes, pRepeatInterval, pFunction)
			local id = pThis:createnewschedulerentryid()
			table.insert(pThis.events, {
				eventuser = pUser,
				eventname = pName,
				eventtime = pTime,
				eventrepeat = pRepeatTimes,
				eventinterval = pRepeatInterval,
				eventfunction = pFunction,
				processevent = function(aThis)
					print(aThis.eventname .. ' event.')
					if tonumber(aThis.eventrepeat) > 0 then	-- repeat is a positive integer, number of repetitions
						aThis:eventfunction()
						aThis.eventrepeat = aThis.eventrepeat - 1
						aThis.eventtime = aThis.eventtime + aThis.eventinterval
					elseif tonumber(aThis.eventrepeat) < 0 then -- repeat is a negative integer, repeat indefinitely
						aThis:eventfunction()
					else -- repeat reached 0, remove event
						pThis.events[id] = nil
					end
				end
			})
			return id
		end,

		-- Deletes the event pointed to by pID
		deleteevent = function(pThis, pID)
			pThis.events[pID] = nil
		end,

		-- Deletes a event checking if it is owned by a certain user
		deleveeventbyuser = function(pThis, pUser, pID)
			if pThis.events[pID] ~= nil then
				if pThis.events[pID].eventuser == pUser then
					pThis:deleteevent(pID)
					return true, "Done."
				else
					return false, "This event id is owned by someone else."
				end
			else
				return false, "This event id does not exist."
			end
		end,

		-- Check events
		checkevents = function(pThis)
			print('scheduler ticks...' .. tostring(pThis.timerticks))
			for _, value in pairs(pThis.events) do
				if pThis.timerticks >= value.eventtime then
					value:processevent()
				end
			end
		end,

		-- List events for a certain user
		listevents = function(pThis, pUser)
			local result = {}
			for _, value in pairs(pThis.events) do
				if value.eventuser == pUser then
					table.insert(result, value)
				end
			end
			return result
		end

	}
end

-- Timer tick ammount of seconds
defaultschedulertimerticks = 60 -- tick each minute

-- Creates a default scheduler
defaultscheduler = createscheduler()

-- Function to activate the default scheduler in a minetest.after event
defaultschedulerfunction = function()
	defaultscheduler.timerticks = defaultscheduler.timerticks + 1
	defaultscheduler:checkevents()
	minetest.after(defaultschedulertimerticks, defaultschedulerfunction)
end
defaultschedulerfunction()
