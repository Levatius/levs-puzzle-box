LinkLuaModifier("mod__delayed_damage", "modifiers/mod__delayed_damage", LUA_MODIFIER_MOTION_NONE)
item_nightlock_mango = class({})


function item_nightlock_mango:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        EmitSoundOn("Item.MoonShard.Consume", caster)
        local mod = caster:FindModifierByName("mod__orb_countdown")
        if mod then
            mod:CountdownComplete()
            caster:AddNewModifier(caster, self, "mod__just_teleported", { duration = 1.0 })
        end
        caster:AddNewModifier(caster, self, "mod__delayed_damage", nil)
    end
end
