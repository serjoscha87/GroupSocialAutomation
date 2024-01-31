
GroupSocialAutomation = LibStub("AceAddon-3.0"):NewAddon("GroupSocialAutomation", "AceConsole-3.0")

GroupSocialAutomation.Events = LibStub("LibMoreEvents-1.0")

--[[
Note on events:
- for Blizzard game events use: GroupSocialAutomation.Events:RegisterEvent
- for custom events use: GroupSocialAutomation.Events:On 
]]

GroupSocialAutomation.Events.CustomCallbacks = {} -- for internal use. Use :On to bind custom events (and :Trigger to ... trigger them)
GroupSocialAutomation.Events.On = function(self, event, closure)
	if GroupSocialAutomation.Events.CustomCallbacks[event] == nil then
		GroupSocialAutomation.Events.CustomCallbacks[event] = {}
	end
	table.insert(GroupSocialAutomation.Events.CustomCallbacks[event], closure)
end

GroupSocialAutomation.Events.Trigger = function(self, event, ...)
	if GroupSocialAutomation.Events.CustomCallbacks[event] == nil or type(GroupSocialAutomation.Events.CustomCallbacks[event]) ~= "table" then
		return
	end
	for _, closure in ipairs(GroupSocialAutomation.Events.CustomCallbacks[event]) do
		closure(...)
	end
end

GroupSocialAutomation.ADDON_NAME = "GroupSocialAutomation"

GroupSocialAutomation_InitStack = {}

-- TODO this crashes every fresh login to a char (not when reloading..)
--table.insert(GroupSocialAutomation_InitStack, function(self)
--GroupSocialAutomation.Events:RegisterEvent("ADDON_LOADED", function ()
GroupSocialAutomation.Events:RegisterEvent("PLAYER_ENTERING_WORLD", function (_, event, isInitialLogin, isReloadingUi)

	if not isInitialLogin and not isReloadingUi then
		return
	end

	-- https://github.com/phanx-wow/LibRealmInfo/wiki/API#getrealminfobyunit
	GroupSocialAutomation.PLAYER_SERVER_LANG = select(5, LibStub("LibRealmInfo"):GetRealmInfoByUnit("player") )
	GroupSocialAutomation.PLAYER_SERVER_NAME = select(2, LibStub("LibRealmInfo"):GetRealmInfoByUnit("player") )

	--print("getting realm info")

	if false then
		C_Timer.After(3, function() 
			DevTool:AddData(GroupSocialAutomation_Funcs.getPossibleMessages("g"), "possible messages greetings")
			DevTool:AddData(GroupSocialAutomation_Funcs.getPossibleMessages("f"), "possible messages farewells")
		end)
	end
	
end)

-- custom [lfd & lfr] player [join & leave] event
GroupSocialAutomation.Events:RegisterEvent("CHAT_MSG_SYSTEM", function (_, _, text)
	for join_leave_id, join_leave_game_str in pairs({JOINED = ERR_INSTANCE_GROUP_ADDED_S, LEFT = ERR_INSTANCE_GROUP_REMOVED_S}) do
		local pattern = join_leave_game_str:gsub("%%s", "([^%%s]+)") -- adjust the string.format() string to become a regular expression we can use to match the player name against
		--print(pattern)
		--print(join_leave_id)
		--print(text)
	    local playerName = string.match(text, pattern)

	    if playerName ~= nil then
	    	playerName = GroupSocialAutomation_Funcs.normalizePlayerName(playerName)

	    	local _, instanceType = IsInInstance()
	    	--[[
	    	instanceType: 
	    	- "none" when outside an instance
			- "pvp" when in a battleground
			- "arena" when in an arena
			- "party" when in a 5-man instance
			- "raid" when in a raid instance
			- "scenario" when in a scenario
	    	]]
	    	if instanceType == "raid" then 
				GroupSocialAutomation.Events:Trigger("LFR_MEMBER_" .. join_leave_id, playerName)
			elseif instanceType == "party" then
				GroupSocialAutomation.Events:Trigger("LFD_MEMBER_" .. join_leave_id, playerName)
			elseif instanceType == "pvp" then
				GroupSocialAutomation.Events:Trigger("BG_MEMBER_" .. join_leave_id, playerName)
			elseif instanceType == "none" then
				GroupSocialAutomation.Events:Trigger("PARTY_MEMBER_" .. join_leave_id, playerName)
			end
		end
	end
end)

--[[
GroupSocialAutomation.Events:On("RAID_MEMBER_JOINED", function(playerName)
	print("_RAID_MEMBER_JOINED", playerName)
end)
GroupSocialAutomation.Events:On("RAID_MEMBER_LEFT", function(playerName)
	print("_RAID_MEMBER_LEFT", playerName)
end)

GroupSocialAutomation.Events:On("LFD_MEMBER_JOINED", function(playerName)
	print("_LFD_MEMBER__JOINED", playerName)
end)
GroupSocialAutomation.Events:On("LFD_MEMBER_LEFT", function(playerName)
	print("_LFD_MEMBER__LEFT", playerName)
end)

GroupSocialAutomation.Events:On("BG_MEMBER_JOINED", function(playerName)
	print("_BG_MEMBER_JOINED", playerName)
end)
GroupSocialAutomation.Events:On("BG_MEMBER_LEFT", function(playerName)
	print("_BG_MEMBER_LEFT", playerName)
end)

GroupSocialAutomation.Events:On("PARTY_MEMBER_JOINED", function(playerName)
	print("_PARTY_MEMBER_JOINED", playerName)
end)
GroupSocialAutomation.Events:On("PARTY_MEMBER_LEFT", function(playerName)
	print("_PARTY_MEMBER_LEFT", playerName)
end)
]]

-- normale raids: ERR_RAID_MEMBER_ADDED_S    ERR_RAID_MEMBER_REMOVED_S 

-- =======================================================

GroupSocialAutomation.Events:RegisterEvent("GROUP_JOINED"--[[when the player him self joins a group]], function (_, event, category, partyGUID)
	GroupSocialAutomation.CURRENT_GROUP_ROSTER = {}
	GroupSocialAutomation.CURRENT_GROUP_REACHED_MAX_ONCE = false -- var to keep track of the current group we are in has ever been at member cap
end)

local partySizes = {
	raid = 25,
	party = 5,
	pvp = -1 -- TODO
}

GroupSocialAutomation.Events:RegisterEvent("GROUP_ROSTER_UPDATE", function ()

	local tempGroupRoster = {}
	local tempGroupRosterCount = 0 -- tracks the amount of connected players for this update

	local newMembers = {} -- will be filled with the players that have JOINED the group since the last time GROUP_ROSTER_UPDATE tirggered

	local _, instanceType = IsInInstance()

	--if instanceType == nil or partySizes[instanceType] == nil then -- die instanceType == nil prüfung sollten wir uns eig sparen können!
	if partySizes[instanceType] == nil then
		return
	end

	-- index members of group
	for i=1, partySizes[instanceType]-1 do
		local partySlotStr = 'party'..i

		local playerConnected = UnitIsConnected(partySlotStr)
		local playerName = UnitName(partySlotStr)
		local playerLevel = UnitLevel(partySlotStr)

		if playerConnected and type(playerLevel) == "number" and playerLevel > 0 then
			--[[table.insert(tempGroupRoster, {
				playerName = playerName,
				playerLevel = playerLevel
			})]]

			tempGroupRosterCount = tempGroupRosterCount + 1

			tempGroupRoster[playerName] = {
				playerLevel = playerLevel,
				playerName = playerName
			}

			if GroupSocialAutomation.CURRENT_GROUP_ROSTER[playerName] == nil then
				table.insert(newMembers, tempGroupRoster[playerName]) 
			end

			-- check for level up .. TODO just make event out of this
			if instanceType == "party" then
				if GroupSocialAutomation.CURRENT_GROUP_ROSTER[playerName] ~= nil and GroupSocialAutomation.CURRENT_GROUP_ROSTER[playerName].playerLevel < playerLevel then
					print (playerName .. " hatte ein level up! Vorher: " .. GroupSocialAutomation.CURRENT_GROUP_ROSTER[playerName].playerLevel .. " & jetzt: " .. playerLevel)
					GroupSocialAutomation.CURRENT_GROUP_ROSTER[playerName].playerLevel = playerLevel
				end
			end

		end
	end

	local lastMemberCount = 0 -- will contain the amount of members the roster had the last time GROUP_ROSTER_UPDATE triggered
	for _ in pairs(GroupSocialAutomation.CURRENT_GROUP_ROSTER) do lastMemberCount = lastMemberCount + 1 end

	--GroupSocialAutomation.CURRENT_GROUP_TYPE_LFD = false
	if instanceType == "party" then
		--print("This is LFD ...")

		--GroupSocialAutomation.CURRENT_GROUP_TYPE_LFD = true

		--print("num members: " .. tempGroupRosterCount)

		local maxPlayers = partySizes["party"] - 1

		if tempGroupRosterCount == maxPlayers then
			--print("... and the party is FULL ...")
			if lastMemberCount == maxPlayers then
				--print("... and is WAS already full BEFORE!")
			else
				--print("... and is WAS NOT full BEFORE!")
				GroupSocialAutomation.Events:Trigger("LFD_MEMBERS_CAPPED", tempGroupRoster, newMembers, not GroupSocialAutomation.CURRENT_GROUP_REACHED_MAX_ONCE)
				GroupSocialAutomation.CURRENT_GROUP_REACHED_MAX_ONCE = true
			end
		else
			--print("... and the party is !!!NOT!! FULL")
			if lastMemberCount == maxPlayers then
				--print("... but it WAS full BEFORE!")
				GroupSocialAutomation.Events:Trigger("LFD_MEMBER_CAP_LOST", tempGroupRoster)
			else
				--print("... and is WAS NOT full BEFORE!")
				--GroupSocialAutomation.Events:Trigger("LFD_MEMBER_COUNT_UNCAPPED", tempGroupRoster, false)
			end
		end
	end

	GroupSocialAutomation.CURRENT_GROUP_ROSTER = tempGroupRoster

	GroupSocialAutomation.Events:Trigger("AFTER_GROUP_ROSTER_UPDATE", tempGroupRoster, newMembers)

end)

--[[GroupSocialAutomation.Events:On("G_R_U", function(roster)
	print("GRU! see dev tool for current state")
	DevTool:AddData(roster, "G_R_U current roster")
end)]]--

GroupSocialAutomation.Events:On("LFD_MEMBERS_CAPPED", function(roster, newMembers, cappedFirstTime)
	print("LFD_MEMBERS_CAPPED (group max of 5 reached)")
	if cappedFirstTime then
		print("-> for the FIRST time in this group")
	else
		print("-> was already capped once before")
	end
	DevTool:AddData(roster, "LFD_MEMBERS_CAPPED current roster")
end)

GroupSocialAutomation.Events:On("LFD_MEMBER_CAP_LOST", function(roster)
	print("LFD_MEMBER_CAP_LOST (group not full ANYMORE (was before)")
	--[[if wasCappedBefore then
		print("... the group was full before")
	else
		print("... the group was NOT full before")
	end]]
	DevTool:AddData(roster, "LFD_MEMBER_CAP_LOST current roster")
end)