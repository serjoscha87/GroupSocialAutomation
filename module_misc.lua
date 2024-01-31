
--local t = time()

GroupSocialAutomation.Events:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", function (_, event, _, subevent, _, _, name)

	--[[
	if time() < t + 5 then
		return
	else
		t = time()
	end
	]]

	local v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13 = CombatLogGetCurrentEventInfo()

	local spellId = v12
	local sourcePlayer = v5

	-- 29893 => seelenbrunnen erschaffen
	-- 43987 => tischlein deck dich -> mana kekse

	--DevTool:AddData({v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13}, "CombatLogGetCurrentEventInfo()")

	if spellId == 29893 then
		print(sourcePlayer .. " hat einen Seelebrunnen erschaffen!")
	end

	if spellId == 43987 then
		print(sourcePlayer .. " hat einen Mana-Keks Tisch aufgestellt!")
	end

end)



GroupSocialAutomation.Events:RegisterEvent("CONFIRM_SUMMON", function (_, event, summonReason, skippingStartExperience)

	local summoner = C_SummonInfo.GetSummonConfirmSummoner()
    
	print(summoner .. " summoned you")

    --[[
    if aura_env.summtimer == nil or GetTime() > aura_env.summtimer + 27 then
        aura_env.summtimer = GetTime() + 3
        
        local summ = select(1, strsplit("-", summname))
        local k = math.random(2) -- Time
        local s = math.random(12) -- Message
        
        local messages = {
            " Thanks for sum " .. summ,
            " Thank you " .. summ,
            " Ty " .. summ,
            " Thanks " .. summ,
            " tyvm " .. summ,
            " ty :) " .. summ,
            summ .. " ty for summ ",
            "thanks " .. summ .. " for summ ",
            summ .. " thanks :) ",
            " cheers " .. summ,
            summ .. " thanks, I am lazy fcker ",
            " ty " .. summ .. " no golds for flying ",
            " Many thanks " .. summ,
            " TY for summ " .. summ
        }
        
        local message = messages[s]
        
        C_Timer.After(k, function() SendChatMessage(message, "PARTY") end)
    end
    ]]

end)