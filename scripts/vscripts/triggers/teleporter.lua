

function OnStartTouch(trigger)
    if IsServer() then
        print("Button trigger entered")
        local trigger_name = thisEntity:GetName()

        local spawn = Entities:FindByName(nil, trigger_name .. "_spawn")
        local hero = EntIndexToHScript(trigger.activator:GetEntityIndex())
        if not hero:HasModifier("mod__just_teleported") then
            hero:SetOrigin(spawn:GetOrigin())
            hero:AddNewModifier(nil, nil, "modifier_phased", { duration = 0.1 })

            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
        end
    end
end