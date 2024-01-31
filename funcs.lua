
GroupSocialAutomation_Funcs = {

    getTimeOfDay = function()
        local currentHour = GetGameTime() -- (also returns the minute, but we don't need it)
        
        if currentHour >= 5 and currentHour < 12 then
            return "morning"
        elseif currentHour >= 12 and currentHour < 17 then
            return "afternoon"
        elseif currentHour >= 17 and currentHour < 20 then
            return "evening"
        elseif currentHour >= 20 or currentHour < 5 then
            return "night"
        else
            return "midday"
        end
    end,

    hasNestedKey = function(table, keyPath)
        local keys = {}
        for key in string.gmatch(keyPath, "[%w_]+") do
            table = table[key]
            if not table then
                return false
            end
        end
        return true
    end,

    getGeneralSettings = function()
        return GroupSocialAutomation.db.global.settings.general
    end,
    getLfdSettings = function()
        return GroupSocialAutomation.db.global.settings.lfd
    end,
    getGeneralSetting = function(key, default) -- todo: this is not able to work with nested stuctures...
        local generalSettings = GroupSocialAutomation_Funcs.getGeneralSettings()
        return generalSettings[key] or default
    end,
    getLfdSetting = function(key, default) -- todo same here
        local lfdSettings = GroupSocialAutomation_Funcs.getLfdSettings()
        return lfdSettings[key] or default
    end,

    translate = function(key)
        local keys = {}
        
        for k in string.gmatch(key, "[^.]+") do
            table.insert(keys, k)
        end

        local translatedValue = GROUPSOCIALAUTOMATION_LOCALIZATIONS
        for _, k in ipairs(keys) do
            translatedValue = translatedValue[k]
            if translatedValue == nil then
                break
            end
        end

        return translatedValue or string.format("[!T] %s", key)
    end,

    --[[
    @param emote table<emoteIdStr, emoteTarget> | string<emoteIdStr>
    ]]
    doSocial = function(messageTable, emote, delay)
    
        if type(messageTable) == "number" then
            print("GroupSocialAutomation error: messageTable is not a table but a number with the value >"..messageTable.."<")
            return
        end

        local rndMsgIndex = math.random(#messageTable)
        local msg = messageTable[rndMsgIndex]
        
        local outputSocial = function ()
            SendChatMessage(msg, "INSTANCE_CHAT") -- TODO instance chat may not be avail @ premade and may also not work in raids...
            if emote ~= nil then
                if type(emote) == "table" then
                    local emoteIdStr, emoteTarget = unpack(emote) 
                    DoEmote(emoteIdStr, emoteTarget)
                else
                    DoEmote(emote, "none") -- "none" => make sure the emore is not executed on a target
                end
            end
        end

        if delay ~= nil then
            local timerDuration = nil
            if type(delay) == "table" then
                timerDuration = math.random(delay[1], delay[2])
            else
                timerDuration = delay
            end

            C_Timer.After(timerDuration, function() 
                outputSocial()
            end)
        else
            -- just run the social interaction immediately
            outputSocial()
        end

    end,

    --[[
    @return msg table | negative number in case of any error where the negative value indicates the error source
    ]]
    getPossibleMessages = function (type --[["greetings" | "farewells" | "g" | "f"]])

        if type ~= "greetings" and type ~= "farewells" and type ~= "g" and type ~= "f" then
            return -1
        end

        if type == "g" then type = "greetings" end
        if type == "f" then type = "farewells" end

        local db = GroupSocialAutomation.db
        --DevTool:AddData(db, "db @ getPossibleMessages")

        local groupTypeIsLFD = GroupSocialAutomation.CURRENT_LFD_PARTY ~= nil
        --local groupTypeIsLFD = true -- ONLY FOR TESTING
        
        local msgLang = nil

        if groupTypeIsLFD then
            -- (because LFD & LFR are ALWAYS in the same lang as the Server the player plays on)
            msgLang = GroupSocialAutomation.PLAYER_SERVER_LANG
        end

        if msgLang == nil then
            return -2
        end

        local allowTimeframeIndependent = db.global.settings.general["setting_" .. msgLang .. "_allow_timeframe_independent"]
        local allowTimeframeDependent = db.global.settings.general["setting_" .. msgLang .. "_allow_timeframe_dependent"]

        local msgStack = {}

        for textRow in string.gmatch(db.global.settings.general["lang_independent_" .. type], "[^\n]+") do
            table.insert(msgStack, textRow)
        end

        if allowTimeframeIndependent then
            for textRow in string.gmatch(db.global.settings.general["setting_" .. msgLang .. "_" .. type], "[^\n]+") do
                table.insert(msgStack, textRow)
            end
        end

        if allowTimeframeDependent then
            local currentTimeFrame = GroupSocialAutomation_Funcs.getTimeOfDay()
            for textRow in string.gmatch(db.global.settings.general["setting_" .. msgLang .. "_" .. type .. "_" .. currentTimeFrame], "[^\n]+") do
                table.insert(msgStack, textRow)
            end
        end

        return msgStack

    end,

    -- returns the playername without the server (if the playername even has a server within)
    normalizePlayerName = function(playerName)
        if playerName ~= nil then
            local pattern = "([^%-%s]+)"
            return string.match(playerName, pattern)
        end
    end
    
}

