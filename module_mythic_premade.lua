GroupSocialAutomation.Events:RegisterEvent("LFG_LIST_APPLICATION_STATUS_UPDATED", function (_, event, searchResultID, newStatus, oldStatus, groupName)
	if newStatus == "inviteaccepted" then
        local sri = C_LFGList.GetSearchResultInfo(searchResultID)
        
        if(sri ~= nil) then
            local activity = C_LFGList.GetActivityInfoTable(sri.activityID)
            local categoryID = activity.categoryID
            
			print("Copied from WA - now coming through GSA -> activityId: " .. sri.activityID .. " / categoryID: " .. categoryID)

			--[[
            if(aura_env.config[""..categoryID]) then
                local returnString
                local title = sri.name
                local zone = activity.fullName
                local leader = sri.leaderName
                
                local categoryTable = {}
				categoryTable[1] = "Quest"
				categoryTable[2] = "Dungeon"
				categoryTable[3] = "Raid"
				categoryTable[4] = "Arena"
				categoryTable[5] = "Scenario"
				categoryTable[6] = "Custom"
				categoryTable[7] = "Skirmish"
				categoryTable[8] = "Battleground"
				categoryTable[9] = "Rated Battleground"
				categoryTable[10] = "Ashran"
				categoryTable[113] = "Torghast"

                returnString = 
	                "Title: "..title..
	                "\nZone: "..zone..
	                "\nCategory: "..categoryTable[categoryID]..
	                "\nLeader: "..leader
                
                if(sri.comment ~= "") then 
                    returnString = returnString.."\nComment: "..sri.comment 
                end
                
                if(aura_env.config["style"] ~= 2) then
                    StaticPopup_Show("GroupReminderPopUp", aura_env.grS.."\n"..returnString.."\n")
                end
                
                print(returnString)

            end
            ]]
        end
    end  
end)