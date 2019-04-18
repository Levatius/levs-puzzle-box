mod__negative_polarity = class({})


function mod__negative_polarity:IsMotionController()
    return true
end

function mod__negative_polarity:GetMotionControllerPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end

function mod__negative_polarity:OnCreated()
    if not IsServer() or self:GetParent() == self:GetCaster() then
        return nil
    end

    self:StartIntervalThink(FrameTime())
end

function mod__negative_polarity:OnIntervalThink()
    if not IsServer() then
        return nil
    end

    local parent = self:GetParent()
    local caster = self:GetCaster()

    local towards
    if parent:HasModifier("aura__negative_polarity") then
        towards = -1
    elseif parent:HasModifier("aura__positive_polarity") then
        towards = 1
    else
        return nil
    end

    local vdistance = caster:GetOrigin() - parent:GetOrigin()
    local distance = vdistance:Length2D()
    local direction = vdistance:Normalized()
    local speed = 240 / parent:GetHullRadius()

    print(vdistance)

    local new_pos = GetGroundPosition(parent:GetOrigin() + towards * direction * speed, parent)
    if GridNav:IsTraversable(new_pos) then
        parent:SetOrigin(new_pos)
    end
end