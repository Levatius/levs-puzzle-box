function OnStartTouch(trigger)
    local hero = EntIndexToHScript(trigger.activator:GetEntityIndex())
    if not hero:HasModifier("mod__just_teleported") then
        print("Weighted orb button entered")

        local heroes = Entities:FindAllByClassname("npc_dota_hero_rubick")
        for _, hero in pairs(heroes) do
            local weighted_orb = hero:FindItemInInventory("item_weighted_orb")
            if weighted_orb then
                weighted_orb:RemoveSelf()
            end
        end

        local drops = Entities:FindAllByClassname("dota_item_drop")
        for _, drop in pairs(drops) do
            if drop:GetContainedItem():GetName() == "item_weighted_orb" then
                local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, drop)
                ParticleManager:SetParticleControl(index, 0, drop:GetOrigin())
                ParticleManager:ReleaseParticleIndex(index)
                drop:GetContainedItem().unit:RemoveSelf()
                drop:RemoveSelf()
            end
        end

        hero:AddItemByName("item_weighted_orb")

        local index = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonfall_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
        ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
    end
end
