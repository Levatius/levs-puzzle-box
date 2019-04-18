mod__wall_invis = class({})


function mod__wall_invis:OnCreated()
    if IsServer() then
        self:GetParent():SetOrigin(Vector(self:GetParent():GetOrigin().x, self:GetParent():GetOrigin().y, self:GetParent().original_z - 128))
    end
end

function mod__wall_invis:OnDestroy()
    if IsServer() then
        self:GetParent():SetOrigin(Vector(self:GetParent():GetOrigin().x, self:GetParent():GetOrigin().y, self:GetParent().original_z))
    end
end

function mod__wall_invis:IsAura()
    return true
end

function mod__wall_invis:GetModifierAura()
    return "mod__no_clip"
end

function mod__wall_invis:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function mod__wall_invis:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function mod__wall_invis:GetAuraRadius()
    return 100
end

function mod__wall_invis:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end