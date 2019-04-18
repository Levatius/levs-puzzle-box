mod__polarity = class({})


function mod__polarity:IsMotionController()
    return true
end

function mod__polarity:GetMotionControllerPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end

function mod__polarity:OnCreated()
    if not IsServer() then
        return nil
    end

    self.polarity = 1

    self:StartIntervalThink(FrameTime())
end

function mod__polarity:OnIntervalThink()
    if not IsServer() then
        return nil
    end

    local parent = self:GetParent()

    local units = Entities:FindAllInSphere(self:GetParent():GetOrigin(), 1000)
    local heading = Vector(0, 0, 0)
    for _, unit in pairs(units) do
        if (unit:GetClassname() == "npc_dota_creature" or unit:GetClassname() == HERO) and unit ~= self:GetParent() and unit:HasModifier("mod__polarity") then
            local vdistance = parent:GetOrigin() - unit:GetOrigin()
            local distance = vdistance:Length2D()
            local direction = vdistance:Normalized()
            local weight = unit:GetHullRadius()
            local polarity = unit:FindModifierByName("mod__polarity").polarity
            --print("name:", unit:GetUnitName(), "distance:", distance, "weight:", weight, "polarity:", polarity)

            heading = heading + self.polarity * polarity * (weight/100) * (1000/distance) * direction
        end
    end

--    if heading ~= Vector(0,0,0) then
--        print(heading:Length2D(), heading)
--    end
    local new_pos = GetGroundPosition(parent:GetOrigin() + 10 * heading, parent)
    if GridNav:IsTraversable(new_pos) then
        parent:SetOrigin(new_pos)
        ResolveNPCPositions(parent:GetOrigin(), 128)
    end
end