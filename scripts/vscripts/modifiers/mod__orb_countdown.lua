mod__orb_countdown = class({})


function mod__orb_countdown:OnCreated()
    if IsServer() then
        self.hero = self:GetParent()
        self.item = self.hero.orb
        AddFOWViewer(DOTA_TEAM_GOODGUYS, self.item:GetOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 1.1, true)
        self:StartIntervalThink(1)
    end
end

function mod__orb_countdown:OnIntervalThink()
    if IsServer() then
        AddFOWViewer(DOTA_TEAM_GOODGUYS, self.item:GetOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 1.1, true)
    end
end

function mod__orb_countdown:CountdownComplete()
    if IsServer() then
        self.hero:SetOrigin(self.item:GetOrigin())
        self.hero:PickupDroppedItem(self.item:GetContainer())

        local index = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hero)
        ParticleManager:SetParticleControl(index, 0, self.hero:GetOrigin())
        ParticleManager:SetParticleControl(index, 1, self.hero:GetOrigin())
        ParticleManager:ReleaseParticleIndex(index)
    end
end