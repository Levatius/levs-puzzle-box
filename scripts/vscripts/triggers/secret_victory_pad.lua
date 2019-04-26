function OnStartTouch(trigger)
    if IsServer() then
        local hero = EntIndexToHScript(trigger.activator:GetEntityIndex())
        if not hero:HasModifier("mod__just_teleported") then
            print("Victory trigger entered")
            if GameRules:IsCheatMode() then
                GameRules:SetCustomVictoryMessage("NO")
                GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
            else
                GameRules:SetCustomVictoryMessage("SECRET SOLUTION FOUND")
                GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
            end
        end
    end
end