
GroupSocialAutomation.CURRENT_LFD_PARTY = nil
GroupSocialAutomation.CURRENT_LFD_PARTY_READY = false
GroupSocialAutomation.CURRENT_LFD_PARTY_LAST_ID = nil

-- custom event of this addon (can only be bound from one place! all other handler attachments will override the previous handler | EDIT: now that we got a new custom event system, this could be easily be bindable from anywhere with a litte effort)
-- fires when LFD group is INITIALLY ready (and all players are connected)
GroupSocialAutomation.Events.LFD_READY = function (partyGUID)
	local delay = GroupSocialAutomation_Funcs.getLfdSetting("wait_time_after_join")

	local possibleMsgs = GroupSocialAutomation_Funcs.getPossibleMessages("g")
	GroupSocialAutomation_Funcs.doSocial(possibleMsgs, "HELLO", delay)

	GroupSocialAutomation.CURRENT_LFD_PARTY_READY = true

	GroupSocialAutomation.CURRENT_LFD_PARTY_LAST_ID = partyGUID
end

local playerLevels = {}

-- Fired when the player enters a group
--[[GroupSocialAutomation.Events:RegisterEvent("GROUP_JOINED", function (_, event, category, partyGUID)

	if category ~= 2 or IsInRaid() then
		return
	end

	GroupSocialAutomation.CURRENT_LFD_PARTY = partyGUID

	print("GROUP_JOINED: " .. category .. " / " .. partyGUID)
	print("LFD_PARTY_LAST_ID: " .. (GroupSocialAutomation.CURRENT_LFD_PARTY_LAST_ID or "--"))
	if partyGUID == GroupSocialAutomation.CURRENT_LFD_PARTY_LAST_ID then
		print("LAST AND NEW ARE THE SAME!")
	else
		print("LAST AND NEW ARE !!NOT!! THE SAME!")
	end

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
				GroupSocialAutomation.Events:LFD_READY(partyGUID)
		    end

		end
		doAwaitGroupConnected()
	else
		GroupSocialAutomation.Events:LFD_READY(partyGUID)
	end

end)]]

--[[
GroupSocialAutomation.Events:RegisterEvent("PARTY_MEMBER_ENABLE", function (self, event, UnitId)
	print("PARTY_MEMBER_ENABLE: " , UnitId)
	GroupSocialAutomation.CURRENT_LFD_PARTY_MEMBER_COUNT = GroupSocialAutomation.CURRENT_LFD_PARTY_MEMBER_COUNT + 1
end)
]]

-- custom lfd player join +  leave behaviour
--[[GroupSocialAutomation.Events:RegisterEvent("CHAT_MSG_SYSTEM", function (_, _, text)

	if IsInRaid() then 
		return
	end

	- -[ [
	LFD GROUPS
	--] ]  
	-- JOIN
	local pattern = ERR_INSTANCE_GROUP_ADDED_S:gsub("%%s", "([^%%s]+)") -- ERR_INSTANCE_GROUP_ADDED_S => "%s ist der Instanzgruppe beigetreten"
    local playerName = string.match(text, pattern)

    if playerName ~= nil then
    	playerName = GroupSocialAutomation_Funcs.normalizePlayerName(playerName)
		GroupSocialAutomation.Events:Trigger("LFD_MEMBER_JOINED", playerName)
	end

	-- LEAVE
	local pattern = ERR_INSTANCE_GROUP_REMOVED_S:gsub("%%s", "([^%%s]+)") -- ERR_INSTANCE_GROUP_REMOVED_S => "%s hat die Instanzgruppe verlassen."
    local playerName = string.match(text, pattern)

    if playerName ~= nil then
    	playerName = GroupSocialAutomation_Funcs.normalizePlayerName(playerName)
		GroupSocialAutomation.Events:Trigger("LFD_MEMBER_LEFT", playerName)
	end

	-- =============================

end)]]

GroupSocialAutomation.Events:On("LFD_MEMBER_JOINED", function(playerName)
	print("LFD MEMBER JOINED!! ", playerName)
end)
GroupSocialAutomation.Events:On("LFD_MEMBER_LEFT", function(playerName)
	print("LFD MEMBER LEFT!! ", playerName)
end)

--GroupSocialAutomation.Events:On("DbReady", function (db)
	--[[GroupSocialAutomation.Events:RegisterEvent("GROUP_ROSTER_UPDATE", function ()
		if GroupSocialAutomation.db ~= nil and GroupSocialAutomation.db.getLfdSetting("congratulate_on_level_up", false) then
			if not GroupSocialAutomation.CURRENT_LFD_PARTY_READY then
				return
			end
			for i=1, 4 do
				local partySlotStr = 'party'..i
				-- todo hier gibt es noch probleme wenn die gruppe schon ready ist, aber leute verlassen / wieder joinen - dann knallt es
				--local playerConnected = UnitIsConnected(partySlotStr)
				local playerName = UnitName(partySlotStr)
				local playerLevel = UnitLevel(partySlotStr)
				if playerName ~= nil and playerLevel ~= nil then
					if playerLevels[playerName] ~= playerLevel then
						print(playerName .. " -> hatte ein level up! Vorher: " .. playerLevels[playerName] .. " - Jetzt: " .. playerLevel)
						C_Timer.After(1, function()
							GroupSocialAutomation_Funcs.doSocial("GZ " .. playerName .. "!", "BYE", playerName)
						end)
						playerLevels[playerName] = playerLevel
					end
				end
			end
		end
	end)]]
--end)
-- das hier wird auch gefeuert wenn jemand ein level up hat...
--[[
GroupSocialAutomation.Events:RegisterEvent("UNIT_LEVEL", function ()
	print("UNIT_LEVEL!")
end)
]]

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
