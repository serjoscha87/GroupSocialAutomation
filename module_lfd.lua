
GroupSocialAutomation.CURRENT_LFD_PARTY = nil
GroupSocialAutomation.CURRENT_LFD_PARTY_READY = false

-- custom event of this addon (can only be bound from one place! all other handler attachments will override the previous handler)
-- fires when LFD group is INITIALLY ready (and all players are connected)
GroupSocialAutomation.Events.LFD_READY = function ()
	local delay = GroupSocialAutomation_Funcs.getLfdSetting("wait_time_after_join")

	local possibleMsgs = GroupSocialAutomation_Funcs.getPossibleMessages("g")
	GroupSocialAutomation_Funcs.doSocial(possibleMsgs, "HELLO", delay)

	GroupSocialAutomation.CURRENT_LFD_PARTY_READY = true
end

local playerLevels = {}

-- Fired when the player enters a group
GroupSocialAutomation.Events:RegisterEvent("GROUP_JOINED", function (_, event, category, partyGUID)

	if category ~= 2 then
		return
	end

	GroupSocialAutomation.CURRENT_LFD_PARTY = partyGUID

	print("GROUP_JOINED: " .. category .. " / " .. partyGUID)

	local awaitGroupConnected = GroupSocialAutomation_Funcs.getLfdSetting("wait_until_all_connected")
	if awaitGroupConnected then
		local function doAwaitGroupConnected()

			local playersConnected = 0

			for i=1, 4 do
				local partySlotStr = 'party'..i
				if UnitIsConnected(partySlotStr) then
					playersConnected = playersConnected + 1
				end
		    end

			if playersConnected < 4 then
				print("group not fully connected/ready - retrying in 1 second")
		    	C_Timer.After(1, doAwaitGroupConnected)
		    else
		    	print("GROUP IS FULL! (exiting checker loop)")
		    	playerLevels = {}
				for i=1, 4 do
					local partySlotStr = 'party'..i
					print("member: " .. UnitName(partySlotStr))
					local playerName = UnitName(partySlotStr)
					local playerLevel = UnitLevel(partySlotStr)
					playerLevels[playerName] = playerLevel
				end
				GroupSocialAutomation.Events:LFD_READY()
		    end

		end
		doAwaitGroupConnected()
	else
		GroupSocialAutomation.Events:LFD_READY()
	end

end)

--[[
GroupSocialAutomation.Events:RegisterEvent("PARTY_MEMBER_ENABLE", function (self, event, UnitId)
	print("PARTY_MEMBER_ENABLE: " , UnitId)
	GroupSocialAutomation.CURRENT_LFD_PARTY_MEMBER_COUNT = GroupSocialAutomation.CURRENT_LFD_PARTY_MEMBER_COUNT + 1
end)
]]

-- ...
GroupSocialAutomation.Events:RegisterEvent("CHAT_MSG_SYSTEM", function (_, _, a, b, c)
	--ERR_INSTANCE_GROUP_ADDED_S  -> "%s ist der Instanzgruppe beigetreten"
	print(">>" .. a .. " -> " .. b .. " -> " .. c)
end)

GroupSocialAutomation.Events:OnDbReady(function (db)	
	if db.getLfdSetting("congratulate_on_level_up", false) then
		GroupSocialAutomation.Events:RegisterEvent("GROUP_ROSTER_UPDATE", function ()
			if not GroupSocialAutomation.CURRENT_LFD_PARTY_READY then
				return
			end
			for i=1, 4 do
				local partySlotStr = 'party'..i
				local playerName = UnitName(partySlotStr)
				local playerLevel = UnitLevel(partySlotStr)
				if playerName ~= nil and playerLevel ~= nil then
					if playerLevels[playerName] ~= playerLevel then
						print(playerName .. " -> hatte ein level up! Vorher: " .. playerLevels[playerName] .. " - Jetzt: " .. playerLevel)
						playerLevels[playerName] = playerLevel
					end
				end
			end
		end)
	end
end)

GroupSocialAutomation.Events:RegisterEvent("LFG_COMPLETION_REWARD", function ()
	local possibleMsgs = GroupSocialAutomation_Funcs.getPossibleMessages("f")
	C_Timer.After(1, function()
		GroupSocialAutomation_Funcs.doSocial(possibleMsgs, "BYE")
	end)
end)

-- Opposite of GROUP_JOINED -> fired when the player leaves a group
GroupSocialAutomation.Events:RegisterEvent("GROUP_LEFT", function ()
	GroupSocialAutomation.CURRENT_LFD_PARTY = nil
	GroupSocialAutomation.CURRENT_LFD_PARTY_READY = false
end)

-- test ... wird das gefeuert wenn wer level up hat?
GroupSocialAutomation.Events:RegisterEvent("UNIT_LEVEL", function ()
	print("UNIT_LEVEL!")
end)
