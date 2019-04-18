LinkLuaModifier("mod__polarity", "modifiers/mod__polarity", LUA_MODIFIER_MOTION_NONE)
polarity = class({})


function polarity:GetIntrinsicModifierName()
    return "mod__polarity"
end

function polarity:OnSpellStart()
    if not IsServer() then
        return nil
    end

    local caster = self:GetCaster()
    caster:SwapAbilities("negative_polarity", "positive_polarity", true, false)

    local mod = caster:AddNewModifier(caster, self, "mod__polarity", nil)
    mod.polarity = mod.polarity * -1
end