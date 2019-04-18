--LinkLuaModifier("mod__polarity", "modifiers/mod__polarity", LUA_MODIFIER_MOTION_NONE)
--negative_polarity = class({})
--
--
--function negative_polarity:OnToggle()
--    if not IsServer() then
--        return nil
--    end
--
--    local caster = self:GetCaster()
--    if self:GetToggleState() then
--        local mod = caster:AddNewModifier(caster, self, "mod__polarity", nil)
--        mod.polarity = -1
--        local positive_polarity_ability = caster:FindAbilityByName("positive_polarity")
--        if positive_polarity_ability and positive_polarity_ability:GetToggleState() then
--            positive_polarity_ability:ToggleAbility()
--        end
--    else
--        caster:RemoveModifierByName("mod__polarity")
--    end
--end

LinkLuaModifier("mod__polarity", "modifiers/mod__polarity", LUA_MODIFIER_MOTION_NONE)
negative_polarity = class({})


function negative_polarity:GetIntrinsicModifierName()
    return "mod__polarity"
end

function negative_polarity:OnSpellStart()
    if not IsServer() then
        return nil
    end

    local caster = self:GetCaster()
    caster:SwapAbilities("negative_polarity", "positive_polarity", false, true)

    local mod = caster:FindModifierByName("mod__polarity")
    mod.polarity = mod.polarity * -1
end