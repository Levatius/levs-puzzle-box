function OnStartTouch(trigger)
    if IsServer() then
        local hero = EntIndexToHScript(trigger.activator:GetEntityIndex())
        if not hero:HasModifier("mod__just_teleported") then
            print("Victory trigger entered")
            GameRules:SetCustomVictoryMessage("LEV-COMPLEX SOLVED")
            GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        end
    end
end