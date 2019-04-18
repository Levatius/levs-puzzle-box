local trigger_active = true

function OnStartTouch()
    if IsServer() then
        print("Button trigger entered")
        local trigger_name = thisEntity:GetName()
        trigger_name = trigger_name:sub(1, trigger_name:len() - 2)

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
        local spawn = Entities:FindByName(nil, trigger_name .. "_spawn")

        if spawn then
            if spawn.count then
                spawn.count = spawn.count + 1
            else
                spawn.count = 1
            end

            if spawn.count == 2 then
                local heroes = Entities:FindAllByClassname("npc_dota_hero_rubick")
                for _, hero in pairs(heroes) do
                    hero:SetOrigin(spawn:GetOrigin())
                    hero:AddNewModifier(nil, nil, "modifier_phased", { duration = 0.1 })
                    hero.respawn_point = spawn:GetOrigin()

                    local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
                    ParticleManager:SetParticleControl(index, 0, hero:GetOrigin())
                    ParticleManager:ReleaseParticleIndex(index)

                    hero.respawn_unit:SetOrigin(hero.respawn_point)

                    EmitSoundOn("ui.set_applied", spawn)

                    if hero.has_triggered_init then
                        hero.has_triggered_init = false
                    end

                    local heroes = Entities:FindAllByClassname("npc_dota_hero_rubick")
                    for _, hero in pairs(heroes) do
                        local weighted_orb = hero:FindItemInInventory("item_weighted_orb")
                        if weighted_orb then
                            weighted_orb:RemoveSelf()
                        end
                    end

                    local drops = Entities:FindAllByClassname("dota_item_drop")
                    for _, drop in pairs(drops) do
                        if drop:GetContainedItem():GetName() == "item_weighted_orb" then
                            local index = ParticleManager:CreateParticle("particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, drop)
                            ParticleManager:SetParticleControl(index, 0, drop:GetOrigin())
                            ParticleManager:ReleaseParticleIndex(index)
                            drop:GetContainedItem().unit:RemoveSelf()
                            drop:RemoveSelf()
                        end
                    end
                end
            end
        end
    end
end

function OnEndTouch()
    print("Button trigger exited")
    local trigger_name = thisEntity:GetName()
    trigger_name = trigger_name:sub(1, trigger_name:len() - 2)

    thisEntity.players_on_pad = thisEntity.players_on_pad - 1

    if trigger_active or thisEntity.players_on_pad > 0 then
        print("Button trigger skip")
        return
    end

    local spawn = Entities:FindByName(nil, trigger_name .. "_spawn")
    spawn.count = spawn.count - 1
    trigger_active = true
end