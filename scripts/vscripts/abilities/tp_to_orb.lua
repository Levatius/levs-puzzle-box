LinkLuaModifier("mod__orb_countdown", "modifiers/mod__orb_countdown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("mod__just_teleported", "modifiers/mod__just_teleported", LUA_MODIFIER_MOTION_NONE)
tp_to_orb = class({})


function tp_to_orb:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local mod = caster:FindModifierByName("mod__orb_countdown")
        if mod then
            mod:CountdownComplete()
            caster:AddNewModifier(caster, self, "mod__just_teleported", { duration = 1.0 })
            EmitSoundOn("Hero_Wisp.TeleportOut.Arc", caster)
        end
    end
end