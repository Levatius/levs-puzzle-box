mod__no_clip = class({})


function mod__no_clip:OnCreated()
    if IsServer() then
        print("OnCreated")
        self:StartIntervalThink(0.05)
    end
end

function mod__no_clip:OnIntervalThink()
    if IsServer() then
        local parent = self:GetParent()
        local wall = Entities:FindByClassnameNearest("npc_dota_creature", parent:GetOrigin(), 300)
        if wall and wall:GetUnitName():sub(1,4) == "wall" then
            if not wall:HasModifier("mod__wall_invis") then
                parent:RemoveModifierByName("mod__no_clip")
            end
        else
            parent:RemoveModifierByName("mod__no_clip")
        end
    end
end

function mod__no_clip:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
    }
end