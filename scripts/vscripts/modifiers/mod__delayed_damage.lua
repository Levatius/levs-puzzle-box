mod__delayed_damage = class({})


function mod__delayed_damage:OnCreated()
    if IsServer() then
        self:StartIntervalThink(0.05)
    end
end

function mod__delayed_damage:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local damage = {
            victim = parent,
            attacker = parent,
            damage = 322,
            damage_type = DAMAGE_TYPE_PURE,
            ability = self
        }
        ApplyDamage(damage)
        UTIL_Remove(self)
    end
end

function mod__delayed_damage:CheckState()
    return {
        [MODIFIER_STATE_STUNNED] = true
    }
end