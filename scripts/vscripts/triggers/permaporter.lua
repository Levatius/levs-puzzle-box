

function OnStartTouch(trigger)
    if IsServer() then
        print("Button trigger entered")
        local trigger_name = thisEntity:GetName()
        local spawn = Entities:FindByName(nil, trigger_name .. "_spawn")
        local hero = EntIndexToHScript(trigger.activator:GetEntityIndex())

        if not hero.has_triggered_init and not thisEntity.triggered then
            local glow = Entities:FindByName(nil, trigger_name .. "_glow")
            UTIL_Remove(glow)

            hero:SetOrigin(spawn:GetOrigin())
            hero:AddNewModifier(nil, nil, "modifier_phased", { duration = 0.1 })
            hero.respawn_point = spawn:GetOrigin()

            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)

            hero.respawn_unit:SetOrigin(hero.respawn_point)
            hero.has_triggered_init = true
            thisEntity.triggered = true
            EmitSoundOn("Hero_Wisp.TeleportIn.Arc", hero)
        end
    end
end