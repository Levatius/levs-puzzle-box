LinkLuaModifier("mod__orb_countdown", "modifiers/mod__orb_countdown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("mod__weighted_orb", "modifiers/mod__weighted_orb", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("mod__banner_vision", "modifiers/mod__banner_vision", LUA_MODIFIER_MOTION_NONE)
drop_orb = class({})


function drop_orb:OnSpellStart()
    local caster = self:GetCaster()

    for i = 0, 8 do
        local item = caster:GetItemInSlot(i)
        if item then
            if item:GetName():sub(1, 12) == "item_teleorb" then
                local owner = item.owner
                caster:DropItemAtPositionImmediate(item, caster:GetOrigin())
                owner.orb = item
                owner:AddNewModifier(caster, self, "mod__orb_countdown", nil)
                if owner.player_type == 0 then
                    item:GetContainer():SetRenderColor(255, 0, 0)
                else
                    item:GetContainer():SetRenderColor(0, 0, 255)
                end
                item:GetContainer():SetOrigin(item:GetContainer():GetOrigin() + Vector(0, 0, 16))
                break
            elseif item:GetName() == "item_weighted_orb" then
                caster:DropItemAtPositionImmediate(item, caster:GetOrigin())
                item:GetContainer():SetRenderColor(255, 255, 0)
                item:GetContainer():SetForwardVector(RandomVector(1))
                item.unit = CreateUnitByName("npc_dota_hero_wisp", item:GetOrigin(), false, item, item, DOTA_TEAM_GOODGUYS)
                item.unit:AddNewModifier(nil, nil, "mod__weighted_orb", nil)
                break
            elseif item:GetName():sub(1, 11) == "item_banner" then
                local owner = item.owner
                caster:DropItemAtPositionImmediate(item, caster:GetOrigin())
                owner.banner = item
                owner:AddNewModifier(caster, self, "mod__banner_vision", nil)
                if owner.player_type == 0 then
                    item:GetContainer():SetRenderColor(255, 150, 150)
                else
                    item:GetContainer():SetRenderColor(150, 150, 255)
                end
                item:GetContainer():SetOrigin(item:GetContainer():GetOrigin() + Vector(0, 0, 8))
                item:GetContainer():SetAngles(0, 0, 0)
                break
            end
        end
    end
end

function drop_orb:CastFilterResult()
    return self:CastResolve(false)
end

function drop_orb:GetCustomCastError()
    return self:CastResolve(true)
end

function drop_orb:CastResolve(error)
    if IsServer() then
        local nearest_wall = Entities:FindByClassnameNearest("npc_dota_creature", self:GetCaster():GetOrigin(), 150)
        if nearest_wall and nearest_wall:HasModifier("mod__wall") then
            if error then
                return "Too close to wall"
            else
                return UF_FAIL_CUSTOM
            end
        end
        if not error then
            return UF_SUCCESS
        end
    end
end
