LinkLuaModifier("mod__negative_polarity", "modifiers/mod__negative_polarity", LUA_MODIFIER_MOTION_NONE)
aura__negative_polarity = class({})


--function aura__negative_polarity:IsAura()
--    return true
--end
--
--function aura__negative_polarity:GetModifierAura()
--    return "mod__negative_polarity"
--end
--
--function aura__negative_polarity:GetAuraSearchTeam()
--    return DOTA_UNIT_TARGET_TEAM_BOTH
--end
--
--function aura__negative_polarity:GetAuraSearchType()
--    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
--end
--
--function aura__negative_polarity:GetAuraSearchFlags()
--    return DOTA_UNIT_TARGET_FLAG_NONE
--end
--
--function aura__negative_polarity:GetAuraRadius()
--    return self:GetAbility():GetSpecialValueFor("aura_radius")
--end

function aura__negative_polarity:OnCreated()
    if not IsServer() then
        return nil
    end

    self:OnIntervalThink()
    self:StartIntervalThink(0.1)
end

function aura__negative_polarity:OnDestroy()
    if not IsServer() then
        return nil
    end

    self:GetParent():SetRenderColor(255, 255, 255)
end

function aura__negative_polarity:OnIntervalThink()
    if not IsServer() then
        return nil
    end

    self:GetParent():SetRenderColor(100, 100, 255)

--    local heroes = Entities:FindAllByClassnameWithin(HERO, self:GetParent():GetOrigin(), self:GetAbility():GetSpecialValueFor("aura_radius"))
--    for _, hero in pairs(heroes) do
--        if hero ~= self:GetParent() then
--            hero:AddNewModifier(self:GetParent(), self:GetAbility(), "mod__negative_polarity", { duration = 0.2 })
--        end
--    end
    local units = Entities:FindAllInSphere(self:GetParent():GetOrigin(), self:GetAbility():GetSpecialValueFor("aura_radius"))
    for _, unit in pairs(units) do
        if unit and (unit:GetClassname() == "npc_dota_creature" or unit:GetClassname() == HERO) and unit ~= self:GetParent() then
            print(unit:GetClassname(), unit:GetUnitName())
            unit:AddNewModifier(self:GetParent(), self:GetAbility(), "mod__negative_polarity", { duration = 0.2 })
        end
    end
end