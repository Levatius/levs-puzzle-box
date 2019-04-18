respawn = class({})


function respawn:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        if caster.respawn_point then
            caster:SetOrigin(caster.respawn_point)
            caster:PickupDroppedItem(caster.orb:GetContainer())

            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
            ParticleManager:ReleaseParticleIndex(index)
        end
    end
end
