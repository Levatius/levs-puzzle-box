function OnStartTouch(trigger)
    if IsServer() then
        print("Switch trigger entered")
        local hero_index = trigger.activator:GetEntityIndex()
        local hero = EntIndexToHScript(hero_index)

        hero.respawn_point = thisEntity:GetOrigin()
        EmitSoundOn("Building_Generic.Destruction", thisEntity)
    end
end