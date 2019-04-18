LinkLuaModifier("mod__wall_invis", "modifiers/mod__wall_invis", LUA_MODIFIER_MOTION_NONE)


local trigger_active = true

function OnStartTouch()
    print("Button trigger entered")
    local trigger_name = thisEntity:GetName()
    local colour = thisEntity:GetName():sub(8)

    if not thisEntity.players_on_pad then
        thisEntity.players_on_pad = 1
    else
        thisEntity.players_on_pad = thisEntity.players_on_pad + 1
    end

    if not trigger_active then
        print("Button trigger skip")
        return
    end

    trigger_active = false

    DoEntFire(trigger_name, "SetAnimation", "ancient_trigger001_down", 0, thisEntity, thisEntity)
    DoEntFire(trigger_name, "SetAnimation", "ancient_trigger001_down_idle", 0.35, thisEntity, thisEntity)

    local walls = Entities:FindAllByClassname("npc_dota_creature")
    for _, wall in pairs(walls) do
        if wall:GetUnitName() == "wall_" .. colour then
            wall:AddNewModifier(nil, nil, "mod__wall_invis", nil)
            EmitSoundOn("Hero_TemplarAssassin.Trap.Trigger", wall)
        end
    end
end

function OnEndTouch()
    print("Button trigger exited")
    local trigger_name = thisEntity:GetName()
    local colour = thisEntity:GetName():sub(8)

    thisEntity.players_on_pad = thisEntity.players_on_pad - 1

    if trigger_active or thisEntity.players_on_pad > 0 then
        print("Button trigger skip")
        return
    end

    DoEntFire(trigger_name, "SetAnimation", "ancient_trigger001_up", 0, thisEntity, thisEntity)
    DoEntFire(trigger_name, "SetAnimation", "ancient_trigger001_idle", 0.35, thisEntity, thisEntity)

    local walls = Entities:FindAllByClassname("npc_dota_creature")
    for _, wall in pairs(walls) do
        if wall:GetUnitName() == "wall_" .. colour then
            wall:RemoveModifierByName("mod__wall_invis")
            EmitSoundOn("Hero_TemplarAssassin.Trap.Cast", wall)
        end
    end

    trigger_active = true
end