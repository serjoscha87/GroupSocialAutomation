--local L = GROUPSOCIALAUTOMATION_LOCALIZATIONS;

--table.insert(GroupSocialAutomation_InitStack, function(self)
GroupSocialAutomation.Events:RegisterEvent("PLAYER_ENTERING_WORLD", function (_, event, isInitialLogin, isReloadingUi)

	if not isInitialLogin and not isReloadingUi then
		return
	end

	local self = GroupSocialAutomation -- otherwise when using the self passed to this function >self< will be a instance of the MoreEvents lib

	local _ = GroupSocialAutomation_Funcs.translate

	--[[
	local generalSetting = function()
		return self.db.global.settings.general
	end
	local lfdSetting = function()
		return self.db.global.settings.lfd
	end
	]]
	local generalSetting = GroupSocialAutomation_Funcs.getGeneralSettings
	local lfdSetting = GroupSocialAutomation_Funcs.getLfdSettings

	--DevTool:AddData(self, "SELF @options")

	--print("making options ready")

	-- note for my late I:
	--  because I know that I will investigate the role of the keys within every "args" table when later looking here again: 
	--  the key names do not matter at all and there are actually no references to these within the addons code! Ace just wants the entries of "args" to be string-keyed....

	local orderIndexes = {
		tabs = 0,
		ot1 = 0, -- optionsTab 1
		ot2 = 0, -- optionsTab 2
		ot3 = 0, -- ...
		ot4 = 0,
		langStrs = 0,
		spacers = 0,
	}

	function order(ot_index, increment)
		if increment == nil then 
			increment = 1 
		end 
		orderIndexes[ot_index] = orderIndexes[ot_index] + increment
		return orderIndexes[ot_index]
	end

	local settingIndex = 0
	function autoSettingIndex()
		settingIndex = settingIndex + 1
		return "setting_" .. settingIndex
	end

	-- @param spacing string <"large", "medium", "small">. Defaults to "medium"
	function spacer(ot_index, spacing)
		if spacing == nil then
			spacing = "medium"
		end
		orderIndexes.spacers = orderIndexes.spacers + 1
		return {
			name = " ",
			fontSize = spacing,
			type = "description",
			order = order(ot_index)
		}
	end

	local options = {
		name = "Group Social Automation " .. _("options"),
		handler = GroupSocialAutomation,
		childGroups = "tab",
		type = "group",
		args = {
			["optionsTab_common"] = { 
				name = _("common"),
				type = "group",
				order = order("tabs"),
				args = {
					--[[
					1. Languages the user speaks
					]]
					[autoSettingIndex()] = {
						name = _("langs you speak"),
						type = "header",
						order = order("ot1")
					},
					[autoSettingIndex()] = {
			            type = "description",
			            name = string.format(
			            	_("you are playing on"), 
			            	string.upper(GroupSocialAutomation.PLAYER_SERVER_NAME), GroupSocialAutomation.PLAYER_SERVER_LANG, 
			            	string.upper(_("clientLangs." .. GroupSocialAutomation.PLAYER_SERVER_LANG))
		            	),
			            order = order("ot1"),
			        },
					-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
					-- lang check boxes are inserted here by a loop afterwards
					-- xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
					[autoSettingIndex()] = {
			            type = "description",
			            name = _("langs you speak description"),
			            order = order("ot1", #GetAvailableLocaleInfo(true)+1),
			        },

			        [autoSettingIndex()] = spacer("ot1", "large"),
			        [autoSettingIndex()] = spacer("ot1", "large"),

					--[[
					2. Group types..
					]]
			        [autoSettingIndex()] = {
						name = _("group types to greet hl"),
						type = "header",
						order = order("ot1")
					},
					[autoSettingIndex()] = {
			            type = "description",
			            name = _("group types to greet description"),
			            order = order("ot1"),
			        },

			        [autoSettingIndex()] = {
						name = "Dungeonbrowser (LFD)",
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting().groupTypesToGreet["lfd"] end,
						set = function(_,val) generalSetting().groupTypesToGreet["lfd"] = val; end
					},

					[autoSettingIndex()] = {
						name = "Premade " .. _("groups"),
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting().groupTypesToGreet["premade"] end,
						set = function(_,val) generalSetting().groupTypesToGreet["premade"] = val; end
					},
					[autoSettingIndex()] = {
			            type = "description",
			            name = string.rep(" ", 9) .. "=> M+ " .. _("groups") .. ",\n" .. string.rep(" ", 9) .. "=> " .. _("group types to greet premade description") .. ".",
			            order = order("ot1"),
			        },

			        [autoSettingIndex()] = {
						name = "Premade Raids",
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting().groupTypesToGreet["premade_raids"] end,
						set = function(_,val) generalSetting().groupTypesToGreet["premade_raids"] = val; end
					},

					[autoSettingIndex()] = {
						name = _("LFR") .. " (LFR)",
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting().groupTypesToGreet["lfr"] end,
						set = function(_,val) generalSetting().groupTypesToGreet["lfr"] = val; end
					},

					[autoSettingIndex()] = spacer("ot1", "large"),
			        [autoSettingIndex()] = spacer("ot1", "large"),

			        --[[
					3. Misc settings
					]]
					[autoSettingIndex()] = {
						name = _("misc settings hl"),
						type = "header",
						order = order("ot1")
					},

					[autoSettingIndex()] = {
						name = _("wait with greeting for joining player buzzword"),
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting()["greet_joining_player_with_name"] end,
						set = function(_,val) generalSetting()["greet_joining_player_with_name"] = val; end
					},
					[autoSettingIndex()] = {
			            type = "description",
			            name = _("wait with greeting for joining player buzzword DESCRIPTION"),
			            order = order("ot1"),
			        },

					[autoSettingIndex()] = {
						name = _("greet joining player with name"),
						type = "toggle",
						order = order("ot1"),
						width = "full",
						get = function() return generalSetting()["greet_joining_player_with_name"] end,
						set = function(_,val) generalSetting()["greet_joining_player_with_name"] = val; end
					},
					[autoSettingIndex()] = {
			            type = "description",
			            name = _("greet joining player with name DESCRIPTION"),
			            order = order("ot1"),
			        },

			        [autoSettingIndex()] = spacer("ot1", "large"),

				}
			}, -- end TAB 1

			["optionsTab_langIndependentStrings"] = { 
				name = _("options tab title lang independent strings"),
				type = "group",
				order = order("tabs"),
				args = {
					[autoSettingIndex()] = {
						name = _("lang independent greetings"),
						type = "input",
						multiline = true,
						order = order("ot2"),
						width = "full",
						get = function() return generalSetting()["lang_independent_greetings"] end,
						set = function(_,val) generalSetting()["lang_independent_greetings"] = val; end
					},

					[autoSettingIndex()] = {
						name = _("lang independent farewells"),
						type = "input",
						multiline = true,
						order = order("ot2"),
						width = "full",
						get = function() return generalSetting()["lang_independent_farewells"] end,
						set = function(_,val) generalSetting()["lang_independent_farewells"] = val; end
					},

				}
			}, -- end TAB 2

			["optionsTab_strings"] = { 
				name = _("options tab title lang bound strings"),
				type = "group",
				order = order("tabs"),
				args = { 
					[autoSettingIndex()] = {
			            type = "description",
			            name = _("info lang bound strings"),
			            order = order("ot3"),
			            fontSize = "medium"
			        },
			        [autoSettingIndex()] = spacer("ot3", "medium"),
					--[[ filled some way down in the loop ]] 
				}
			},

			["optionsTab_lfd"] = { 
				name = "LFD",
				type = "group",
				order = order("tabs"),
				hidden = function ()
					return not generalSetting().groupTypesToGreet.lfd
				end,
				args = { 
					[autoSettingIndex()] = {
						name = _("lfd tab description"),
						type = "description",
						order = order("ot4"),
						fontSize = "medium"
					},

					[autoSettingIndex()] = spacer("ot4", "large"),

					[autoSettingIndex()] = {
						name = _("wait until all connected"),
						type = "toggle",
						order = order("ot4"),
						width = "full",
						get = function() return lfdSetting().wait_until_all_connected end,
						set = function(_,val) lfdSetting().wait_until_all_connected = val; end
					},

					[autoSettingIndex()] = spacer("ot4", "small"),

					[autoSettingIndex()] = {
			            type = "description",
			            name = _("wait time after join"),
			            order = order("ot4"),
			        },
					[autoSettingIndex()] = {
						name = "",
						type = "input",
						order = order("ot4"),
						width = 0.3,
						descStyle  = "inline",
						get = function() return lfdSetting().wait_time_after_join end,
						set = function(_,val) lfdSetting().wait_time_after_join = val; end,
						validate = function(info, value)
			                local numberValue = tonumber(value)
			                if not numberValue then
			                    return _("error must be a number")
			                end
			                return true
			            end,
					},
					[autoSettingIndex()] = {
						name = _("seconds"),
						type = "description",
						order = order("ot4"),
						width = 0.5,
						fontSize = "medium"
					},

					[autoSettingIndex()] = spacer("ot4", "medium"),

					[autoSettingIndex()] = {
						name = _("congratulate players on level up"),
						type = "toggle",
						order = order("ot4"),
						width = "full",
						get = function() return lfdSetting()["congratulate_on_level_up"] end,
						set = function(_,val) lfdSetting()["congratulate_on_level_up"] = val; end
					}
					
				}
			},

		}
	}

	-- add the language selects for "langs you speak" + dyn text boxes for the lang strings
  	for i, locale in ipairs(GetAvailableLocaleInfo(true)) do

		local langAbbreviation = locale.localeName

		options.args["optionsTab_common"].args["setting_usl_" .. i] = {
			name = _("clientLangs." .. langAbbreviation),
			type = "toggle",
			order = i+1, -- +1 because the headline has the first spot
			get = function() return generalSetting().userSpokenLangs[langAbbreviation] end,
			set = function(_,val) generalSetting().userSpokenLangs[langAbbreviation] = val; end
		}
		-- force the lang of the server we are playing on to be always selected and being not de-selectable
		if langAbbreviation == GroupSocialAutomation.PLAYER_SERVER_LANG then
			options.args["optionsTab_common"].args["setting_usl_" .. i].disabled = true
			C_Timer.After(2, function() -- the "db" is not available at this point (because its initialized some way down) - so lets just go the hacky way, detach this small action from the main worker process and and wait a moment
				generalSetting().userSpokenLangs[langAbbreviation] = true
			end)
			
		end

		-- generate common string tabs for each client language
		options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation] = {
			name = _("clientLangs." .. langAbbreviation),
			type = "group",
			order = order("langStrs"),
			disabled = function () 
				return not generalSetting().userSpokenLangs[langAbbreviation]
			end,
			args = {
				[autoSettingIndex()] = {
					name = _("greetings"),
					type = "input",
					multiline = true,
					order = order("ot3", 2), -- move this 2 position forth so we can add a checkbox defined afterwards BEFORE this config element
					width = "full",
					get = function() return generalSetting()["setting_" .. langAbbreviation .. "_greetings"] end,
					set = function(_,val) generalSetting()["setting_" .. langAbbreviation .. "_greetings"] = val; end,
					hidden = function () 
						return not generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_independent"]
					end
				},
				[autoSettingIndex()] = {
					name = _("farewells"),
					type = "input",
					multiline = true,
					order = order("ot3"),
					width = "full",
					get = function() return generalSetting()["setting_" .. langAbbreviation .. "_farewells"] end,
					set = function(_,val) generalSetting()["setting_" .. langAbbreviation .. "_farewells"] = val; end,
					hidden = function () 
						return not generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_independent"]
					end
				},
			}
		}

		options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation].args[autoSettingIndex()] = {
			name = _("generally allow use of daytime independent texts"),
			type = "toggle",
			order = order("ot3") - 2, -- make this being displayed BEFORE the actually previously defined textareas
			width = "full",
			get = function() return generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_independent"] end,
			set = function(_,val) generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_independent"] = val; end
		}

		options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation].args[autoSettingIndex()] = spacer("ot3", "large")

		options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation].args[autoSettingIndex()] = {
			name = _("generally allow use of daytime dependent texts"),
			type = "toggle",
			order = order("ot3"),
			width = "full",
			get = function() return generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_dependent"] end,
			set = function(_,val) generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_dependent"] = val; end
		}

		-- generate greeting & farewell setting-boxes for all possible timeframes
		local timeFrames = {"morning", "afternoon", "evening", "night", "midday"} 
		for i=1, 2 do

			local currentType = ({"greetings", "farewells"})[i]

			options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation].args[autoSettingIndex()] = {
				name = _("daytime dependent " .. currentType),
				type = "header",
				order = order("ot3"),
				hidden = function () 
					return not generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_dependent"]
				end
			}

		  	for i, tf in ipairs(timeFrames) do
		  		options.args["optionsTab_strings"].args["setting_strings_" .. langAbbreviation].args[autoSettingIndex()] = {
					name = _("daytimes." .. tf),
					type = "input",
					multiline = true,
					order = order("ot3"),
					width = "full",
					get = function() return generalSetting()["setting_" .. langAbbreviation .. "_" .. currentType .. "_" .. tf] end,
					set = function(_,val) generalSetting()["setting_" .. langAbbreviation .. "_" .. currentType .. "_" .. tf] = val; end,
					hidden = function () 
						return not generalSetting()["setting_" .. langAbbreviation .. "_allow_timeframe_dependent"]
					end
				}
		  	end
	    end

  	end

	self.db = LibStub("AceDB-3.0"):New("GroupSocialAutomation_DB", GroupSocialAutomation.OPTION_DEFAULTS)
	self.db.lfdSettings = GroupSocialAutomation_Funcs.getLfdSettings
	self.db.generalSettings = GroupSocialAutomation_Funcs.getGeneralSettings
	self.db.getLfdSetting = GroupSocialAutomation_Funcs.getLfdSetting
	self.db.getGeneralSetting = GroupSocialAutomation_Funcs.getGeneralSetting
	GroupSocialAutomation.Events:Trigger("DbReady", self.db)

	local BlizzardOptionsPanelTitle = "GroupSocialAutomation" -- the title on the left side that gives access to the actual addon config panels
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable(BlizzardOptionsPanelTitle, options)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions(BlizzardOptionsPanelTitle, ADDON_NAME)

	self:RegisterChatCommand("gsa", function ()
	    LibStub("AceConfigDialog-3.0"):Open(BlizzardOptionsPanelTitle)
	end)

end)