mod__weighted_orb = class({})


function mod__weighted_orb:OnCreated()
    if not IsServer() then
        return nil
    end
    self:GetParent():AddNoDraw()
end

function mod__weighted_orb:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true
    }
end