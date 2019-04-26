require("config")
LinkLuaModifier("mod__wall", "modifiers/mod__wall", LUA_MODIFIER_MOTION_NONE)


if PuzzleBox == nil then
    PuzzleBox = class({})
end

function Precache(ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_techies.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_items.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds.vsndevts", ctx)
    PrecacheResource("soundfile", "soundevents/game_sounds_ui_imported.vsndevts", ctx)
    PrecacheResource("particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_cast_moonfall_gold.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/items/wisp/wisp_relocate_teleport_ti7.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/wards/smeevil/smeevil_ward/smeevil_ward_yellow_ambient.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/wards/smeevil/smeevil_ward/smeevil_ward_blue_ambient.vpcf", ctx)
    PrecacheResource("particle", "particles/econ/wards/smeevil/smeevil_ward/smeevil_ward_pink_ambient.vpcf", ctx)
end

-- Create the game mode when we activate
function Activate()
    GameRules.AddonTemplate = PuzzleBox()
    GameRules.AddonTemplate:InitGameMode()
end

function PuzzleBox:InitGameMode()
    print("Lev's Puzzle Box loaded")
    self.player_type_counter = 0
    self:SetupGameRules()
    print("Rules applied")
    self:BuildingsToUnits()
    print("Buildings converted")

    Convars:RegisterCommand("spawn_friend", Dynamic_Wrap(PuzzleBox, "SpawnFriendCmd"), nil, FCVAR_CHEAT)

    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(PuzzleBox, "OnItemPickedUp"), self)
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(PuzzleBox, "OnNPCSpawned"), self)
    ListenToGameEvent("dota_on_hero_finish_spawn", Dynamic_Wrap(PuzzleBox, "OnHeroFinishSpawn"), self)

    GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 1)
end

function PuzzleBox:OnThink()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        local items = Entities:FindAllByClassname("item_datadriven")
        for _, item in pairs(items) do
            if item:GetContainer() and item:GetName():sub(1, 12) == "item_teleorb" then
                if not item.owner:HasModifier("mod__orb_countdown") then
                    print("Readding orb modifier to owner")
                    item.owner:AddNewModifier(item.owner, item.owner:FindAbilityByName("drop_orb"), "mod__orb_countdown", nil)
                end
            end
        end
    end
    return 1
end

function PuzzleBox:SetupGameRules()
    GameRules:SetHeroRespawnEnabled(true)
    GameRules:SetHeroSelectionTime(0)
    GameRules:SetStrategyTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetPreGameTime(0)
    GameRules:SetPostGameTime(60)
    GameRules:SetStartingGold(0)
    GameRules:SetGoldTickTime(999999)
    GameRules:SetGoldPerTick(0)
    GameRules:SetSafeToLeave(true)
    GameRules:SetFirstBloodActive(false)
    GameRules:SetCustomGameSetupTimeout(10)
    GameRules:SetCustomGameSetupAutoLaunchDelay(10)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 2)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)

    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetDaynightCycleDisabled(true)
    GameMode:SetBuybackEnabled(false)
    GameMode:SetLoseGoldOnDeath(false)
    GameMode:SetUnseenFogOfWarEnabled(true)
    GameMode:SetHudCombatEventsDisabled(true)
    GameMode:SetPauseEnabled(false)
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetCustomGameForceHero(HERO)
    GameMode:SetCameraDistanceOverride(1500)
    GameMode:SetFixedRespawnTime(3)
end

function PuzzleBox:BuildingsToUnits()
    if not IsServer() then
        return nil
    end

    local units = Entities:FindAllByClassname("npc_dota_building")
    for _, unit in pairs(units) do
        local new_unit
        if string.match(unit:GetName(), "wall_") then
            new_unit = CreateUnitByName("wall", unit:GetOrigin(), true, nil, nil, 0)
            new_unit:AddNewModifier(nil, nil, "mod__wall", nil)
        end

        local colour_tint = unit:GetRenderColor()
        new_unit:SetRenderColor(colour_tint.x, colour_tint.y, colour_tint.z)

        new_unit:SetUnitName(unit:GetName())
        new_unit:SetOrigin(unit:GetOrigin())
        new_unit.original_z = new_unit:GetOrigin().z

        local angles = unit:GetAnglesAsVector()
        new_unit:SetAngles(angles.x, angles.y, angles.z)

        local model = unit:GetModelName()
        new_unit:SetModel(model)
        new_unit:SetOriginalModel(model)

        local scale = unit:GetModelScale()
        new_unit:SetModelScale(scale)

        new_unit:SetNeverMoveToClearSpace(true)

        unit:RemoveSelf()
    end
end

function PuzzleBox:OnHeroFinishSpawn(keys)
    print("OnHeroFinishSpawn")
    local hero = EntIndexToHScript(keys.heroindex)
    if hero and not hero.first_spawned then
        hero.first_spawned = true
        hero.player_type = self.player_type_counter
        self:SetupHero(hero)
        self:InitialItems(hero)
        self:SetInitialSpawnPoint(hero)
        self.player_type_counter = self.player_type_counter + 1

        if PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS) == 1 then
            self:SpawnFriend(hero)
        end
    end
end

function PuzzleBox:SetupHero(hero)
    hero.respawn_unit = CreateUnitByName("spawn", hero:GetOrigin(), true, hero, hero, DOTA_TEAM_GOODGUYS)
    if string.match(GetMapName(), "timelapse") then
        if hero.player_type == 0 then
            PlayerResource:SetCustomPlayerColor(hero:GetPlayerID(), 255, 0, 0)
            hero:SetRenderColor(255, 0, 0)
            hero.respawn_unit.index = ParticleManager:CreateParticle("particles/econ/wards/smeevil/smeevil_ward/smeevil_ward_yellow_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero.respawn_unit)
        else
            PlayerResource:SetCustomPlayerColor(hero:GetPlayerID(), 0, 0, 255)
            hero:SetRenderColor(0, 0, 255)
            hero.respawn_unit.index = ParticleManager:CreateParticle("particles/econ/wards/smeevil/smeevil_ward/smeevil_ward_blue_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero.respawn_unit)
        end
    end

    hero.respawn_unit:AddNewModifier(nil, nil, "modifier_phased", nil)
    hero.respawn_unit:AddNewModifier(nil, nil, "modifier_no_healthbar", nil)

    for i = 0, 6 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(1)
        end
    end
end

function PuzzleBox:InitialItems(hero)
    local starting_tp = hero:FindItemInInventory("item_tpscroll")
    if starting_tp then
        UTIL_Remove(starting_tp)
    end

    if self.player_type_counter == 0 then
        hero:AddItemByName("item_teleorb_red")
        if GetMapName() == "timelapse_4" then
            hero:AddItemByName("item_banner_red")
        end
    else
        hero:AddItemByName("item_teleorb_blue")
        if GetMapName() == "timelapse_4" then
            hero:AddItemByName("item_banner_blue")
        end
    end
    hero:SwapItems(0, 1)

    hero:AddItemByName("item_nightlock_mango")
    hero:SwapItems(0, 2)

    for i = 0, 8 do
        local item = hero:GetItemInSlot(i)
        if item then
            print("Setting item owners", item:GetName())
            item.owner = hero
        end
    end
end

function PuzzleBox:SetInitialSpawnPoint(hero)
    if IsServer() then
        local spawn = Entities:FindByClassnameNearest("info_player_start_goodguys", hero:GetOrigin(), 99999)
        if spawn then
            hero.respawn_point = spawn:GetOrigin()
            hero.respawn_unit:SetOrigin(hero.respawn_point)
            hero:SetOrigin(hero.respawn_point)
            UTIL_Remove(spawn)
        end
    end
end

function PuzzleBox:OnNPCSpawned(event)
    print("OnNPCSpawned")
    local npc = EntIndexToHScript(event.entindex)
    if npc then
        if npc.banner then
            npc:SetOrigin(npc.banner:GetOrigin())
        elseif npc.respawn_point then
            npc:SetOrigin(npc.respawn_point)
        end
    end
end

function PuzzleBox:OnItemPickedUp(event)
    local item = EntIndexToHScript(event.ItemEntityIndex)

    if item:GetName():sub(1, 12) == "item_teleorb" then
        local owner = item.owner
        if owner and owner:HasModifier("mod__orb_countdown") then
            owner:RemoveModifierByName("mod__orb_countdown")
        end
    elseif item:GetName() == "item_weighted_orb" then
        item.unit:RemoveSelf()
    elseif item:GetName():sub(1, 11) == "item_banner" then
        local owner = item.owner
        owner.banner = nil
        if owner and owner:HasModifier("mod__banner_vision") then
            owner:RemoveModifierByName("mod__banner_vision")
        end
    end
end

function PuzzleBox:SpawnFriend(hero)
    local unit = CreateUnitByName(HERO, hero:GetOrigin(), true, hero, hero, DOTA_TEAM_GOODGUYS)
    unit:SetControllableByPlayer(hero:GetPlayerID(), false)
    self:SetupHero(unit)
    self:InitialItems(unit)
    self:SetInitialSpawnPoint(unit)
end

function PuzzleBox:SpawnFriendCmd()
    local cmd_player = Convars:GetCommandClient()
    if cmd_player then
        local hero = cmd_player:GetAssignedHero()
        local player_id = cmd_player:GetPlayerID()
        if player_id ~= nil and player_id ~= -1 then
            PuzzleBox:SpawnFriend(hero)
        end
    end
end