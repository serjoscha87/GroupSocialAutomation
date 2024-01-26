
GroupSocialAutomation = LibStub("AceAddon-3.0"):NewAddon("GroupSocialAutomation", "AceConsole-3.0")

GroupSocialAutomation.Events = LibStub("LibMoreEvents-1.0")

GroupSocialAutomation.Events.OnDbReadyCallbacks = {} -- for internal use
GroupSocialAutomation.Events.OnDbReady = function(self, closure)
	table.insert(GroupSocialAutomation.Events.OnDbReadyCallbacks, closure)
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

