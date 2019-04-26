mod__banner_vision = class({})


function mod__banner_vision:IsHidden()
    return true
end

function mod__banner_vision:RemoveOnDeath()
    return false
end

function mod__banner_vision:OnCreated()
    if IsServer() then
        self.hero = self:GetParent()
        self.item = self.hero.banner
        AddFOWViewer(DOTA_TEAM_GOODGUYS, self.item:GetOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 1.1, true)
        self:StartIntervalThink(1)
    end
end

function mod__banner_vision:OnIntervalThink()
    if IsServer() then
        AddFOWViewer(DOTA_TEAM_GOODGUYS, self.item:GetOrigin(), self:GetAbility():GetSpecialValueFor("vision_radius"), 1.1, true)
    end
end