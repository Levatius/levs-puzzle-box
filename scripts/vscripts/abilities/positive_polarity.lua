--LinkLuaModifier("mod__polarity", "modifiers/mod__polarity", LUA_MODIFIER_MOTION_NONE)
--positive_polarity = class({})
--
--
--function positive_polarity:OnToggle()
--    if not IsServer() then
--        return nil
--    end
--
--    local caster = self:GetCaster()
--    if self:GetToggleState() then
--        local mod = caster:AddNewModifier(caster, self, "mod__polarity", nil)
--        mod.polarity = 1
--        local negative_polarity_ability = caster:FindAbilityByName("negative_polarity")
--        if negative_polarity_ability and negative_polarity_ability:GetToggleState() then
--            negative_polarity_ability:ToggleAbility()
--        end
--    else
--        caster:RemoveModifierByName("mod__polarity")
--    end
--end

LinkLuaModifier("mod__polarity", "modifiers/mod__polarity", LUA_MODIFIER_MOTION_NONE)
positive_polarity = class({})


function positive_polarity:GetIntrinsicModifierName()
    return "mod__polarity"
end

function positive_polarity:OnSpellStart()
    if not IsServer() then
        return nil
    end

    local caster = self:GetCaster()
    caster:SwapAbilities("negative_polarity", "positive_polarity", true, false)

    local mod = caster:FindModifierByName("mod__polarity")
    mod.polarity = mod.polarity * -1
end