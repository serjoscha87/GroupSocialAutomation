--[[ 
GroupSocialAutomation.Events:RegisterEvent("GROUP_JOINED", function (_, event, category, partyGUID)

	if category ~= 2 or not IsInRaid() then
		return
	end

	print("RAID beigetreten!")

end)

GroupSocialAutomation.Events:RegisterEvent("CHAT_MSG_SYSTEM", function (_, _, text)

	if not IsInRaid() then 
		return
	end

	-- FROM HERE ON COPY PASTE FROM LFD

	-- JOIN
	local pattern = ERR_INSTANCE_GROUP_ADDED_S:gsub("%%s", "([^%%s]+)") -- ERR_INSTANCE_GROUP_ADDED_S => "%s ist der Instanzgruppe beigetreten"
    local playerName = string.match(text, pattern)

    if playerName ~= nil then
    	playerName = GroupSocialAutomation_Funcs.normalizePlayerName(playerName)
		GroupSocialAutomation.Events:Trigger("RAID_MEMBER_JOINED", playerName)
	end

	-- LEAVE
	local pattern = ERR_INSTANCE_GROUP_REMOVED_S:gsub("%%s", "([^%%s]+)") -- ERR_INSTANCE_GROUP_REMOVED_S => "%s hat die Instanzgruppe verlassen."
    local playerName = string.match(text, pattern)

    if playerName ~= nil then
    	playerName = GroupSocialAutomation_Funcs.normalizePlayerName(playerName)
		GroupSocialAutomation.Events:Trigger("RAID_MEMBER_LEFT", playerName)
	end

end)

GroupSocialAutomation.Events:On("RAID_MEMBER_JOINED", function(playerName)
	print("RAID MEMBER JOINED!! ", playerName)
end)
GroupSocialAutomation.Events:On("RAID_MEMBER_LEFT", function(playerName)
	print("RAID MEMBER LEFT!! ", playerName)
end)
]]