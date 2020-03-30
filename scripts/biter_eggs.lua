local BiterEggs = {}
local Utils = require("utility/utils")
local Events = require("utility/events")
local Logging = require("utility/logging")
local EventScheduler = require("utility/event-scheduler")
local BiterSelection = require("utility/functions/biter-selection")

BiterEggs.OnLoad = function()
    Events.RegisterEvent(defines.events.on_entity_died, "EggNests", {{filter = "name", name = "biter-egg-nest-large"}, {filter = "name", name = "biter-egg-nest-small"}})
    Events.RegisterHandler(defines.events.on_entity_died, "BiterEggs.OnEntityDiedEggNests", BiterEggs.OnEntityDiedEggNests)
    EventScheduler.RegisterScheduledEventType("BiterEggs.EggPostDestroyed", BiterEggs.EggPostDestroyed)

    local eggPostDestroyed_eventId = Events.RegisterEvent("BiterEggs.EggPostDestroyed")
    remote.remove_interface("biter_eggs")
    remote.add_interface(
        "biter_eggs",
        {
            get_egg_post_destroyed_event_id = function()
                return eggPostDestroyed_eventId
            end
        }
    )
end

BiterEggs.CreateGlobals = function()
    global.Settings = global.Settings or {}
    global.Settings.biterSpawnChance = global.Settings.biterSpawnChance or 0
    global.Settings.wormSpawnChance = global.Settings.wormSpawnChance or 0
    global.Settings.eggNedstDiedActionChanceList = global.Settings.eggNedstDiedActionChanceList or {}
    global.Settings.eggNestLargeBiterMinCount = global.Settings.eggNestLargeBiterMinCount or 0
    global.Settings.eggNestLargeBiterMaxCount = global.Settings.eggNestLargeBiterMaxCount or 0
    global.Settings.eggNestSmallBiterMinCount = global.Settings.eggNestSmallBiterMinCount or 0
    global.Settings.eggNestSmallBiterMaxCount = global.Settings.eggNestSmallBiterMaxCount or 0
    global.Settings.eggNestLargeWormMinCount = global.Settings.eggNestLargeWormMinCount or 0
    global.Settings.eggNestLargeWormMaxCount = global.Settings.eggNestLargeWormMaxCount or 0
    global.Settings.eggNestSmallWormMinCount = global.Settings.eggNestSmallWormMinCount or 0
    global.Settings.eggNestSmallWormMaxCount = global.Settings.eggNestSmallWormMaxCount or 0
end

BiterEggs.UpdateSetting = function(settingName)
    if settingName == "biters-per-large-egg-nest-min" or settingName == nil then
        global.Settings.eggNestLargeBiterMinCount = tonumber(settings.global["biters-per-large-egg-nest-min"].value)
    end
    if settingName == "biters-per-large-egg-nest-max" or settingName == nil then
        global.Settings.eggNestLargeBiterMaxCount = tonumber(settings.global["biters-per-large-egg-nest-max"].value)
    end
    if settingName == "biters-per-small-egg-nest-min" or settingName == nil then
        global.Settings.eggNestSmallBiterMinCount = tonumber(settings.global["biters-per-small-egg-nest-min"].value)
    end
    if settingName == "biters-per-small-egg-nest-max" or settingName == nil then
        global.Settings.eggNestSmallBiterMaxCount = tonumber(settings.global["biters-per-small-egg-nest-max"].value)
    end
    if settingName == "worms-per-large-egg-nest-min" or settingName == nil then
        global.Settings.eggNestLargeWormMinCount = tonumber(settings.global["worms-per-large-egg-nest-min"].value)
    end
    if settingName == "worms-per-large-egg-nest-max" or settingName == nil then
        global.Settings.eggNestLargeWormMaxCount = tonumber(settings.global["worms-per-large-egg-nest-max"].value)
    end
    if settingName == "worms-per-small-egg-nest-min" or settingName == nil then
        global.Settings.eggNestSmallWormMinCount = tonumber(settings.global["worms-per-small-egg-nest-min"].value)
    end
    if settingName == "worms-per-small-egg-nest-max" or settingName == nil then
        global.Settings.eggNestSmallWormMaxCount = tonumber(settings.global["worms-per-small-egg-nest-max"].value)
    end

    local chanceUpdated = false
    if settingName == "egg-nest-biter-chance" or settingName == nil then
        global.Settings.biterSpawnChance = tonumber(settings.global["egg-nest-biter-chance"].value)
        chanceUpdated = true
    end
    if settingName == "egg-nest-worm-chance" or settingName == nil then
        global.Settings.wormSpawnChance = tonumber(settings.global["egg-nest-worm-chance"].value)
        chanceUpdated = true
    end
    if chanceUpdated then
        local dataSet = {
            {name = "biters", chance = global.Settings.biterSpawnChance},
            {name = "worms", chance = global.Settings.wormSpawnChance}
        }
        global.Settings.eggNedstDiedActionChanceList = Utils.NormaliseChanceList(dataSet, "chance", true)
    end
end

BiterEggs.OnEntityDiedEggNests = function(event)
    local deadEntity = event.entity
    EventScheduler.ScheduleEvent(
        event.tick + 1,
        "BiterEggs.EggPostDestroyed",
        deadEntity.unit_number,
        {
            surface = deadEntity.surface,
            position = deadEntity.position,
            force = deadEntity.force,
            entityType = deadEntity.name,
            killerEntity = event.cause
        }
    )
end

BiterEggs.EggPostDestroyed = function(event)
    local eggNestDetails = event.data
    local actionChance = Utils.GetRandomEntryFromNormalisedDataSet(global.Settings.eggNedstDiedActionChanceList, "chance")
    local actionName
    if actionChance ~= nil then
        actionName = actionChance.name
    end
    Events.RaiseEvent({name = "BiterEggs.EggPostDestroyed", actionName = actionName, eggNestDetails = eggNestDetails})
    if actionChance == nil then
        return
    end
    if actionName == "biters" then
        BiterEggs.CreateBiters(eggNestDetails)
    elseif actionName == "worms" then
        BiterEggs.CreateWorms(eggNestDetails)
    end
end

BiterEggs.CreateBiters = function(eggNestDetails)
    local surface = eggNestDetails.surface
    local targetPosition = eggNestDetails.position
    local biterForce = eggNestDetails.force
    local eggNestType = eggNestDetails.entityType
    local attackCommandTarget = eggNestDetails.killerEntity

    local bitersToSpawn = 0
    if eggNestType == "biter-egg-nest-large" then
        bitersToSpawn = math.random(global.Settings.eggNestLargeBiterMinCount, global.Settings.eggNestLargeBiterMaxCount)
    elseif eggNestType == "biter-egg-nest-small" then
        bitersToSpawn = math.random(global.Settings.eggNestSmallBiterMinCount, global.Settings.eggNestSmallBiterMaxCount)
    end
    if bitersToSpawn == 0 then
        return
    end
    local spawnerTypes = {"biter-spawner", "spitter-spawner"}
    local eggSpawnerType = spawnerTypes[math.random(2)]
    local evolution = Utils.RoundNumberToDecimalPlaces(biterForce.evolution_factor, 3)
    local unitGroup
    if attackCommandTarget ~= nil and attackCommandTarget.valid then
        unitGroup = surface.create_unit_group {position = targetPosition, force = biterForce}
    end
    for i = 1, bitersToSpawn do
        local biterType = BiterSelection.GetBiterType("biters", eggSpawnerType, evolution)
        local foundPosition = surface.find_non_colliding_position(biterType, targetPosition, 0, 1)
        if foundPosition ~= nil then
            local biter = surface.create_entity {name = biterType, position = foundPosition, force = biterForce, raise_built = true}
            if biter ~= nil and unitGroup ~= nil then
                unitGroup.add_member(biter)
            end
        end
    end
    if unitGroup ~= nil then
        unitGroup.set_command({type = defines.command.go_to_location, destination = attackCommandTarget.position})
    end
end

BiterEggs.CreateWorms = function(eggNestDetails)
    local surface = eggNestDetails.surface
    local targetPosition = eggNestDetails.position
    local biterForce = eggNestDetails.force
    local eggNestType = eggNestDetails.entityType

    local wormsToSpawn, randomRadius, singleWormXRandomOffset = 0, 0.5, 0
    if eggNestType == "biter-egg-nest-large" then
        wormsToSpawn = math.random(global.Settings.eggNestLargeWormMinCount, global.Settings.eggNestLargeWormMaxCount)
        singleWormXRandomOffset = 1
    elseif eggNestType == "biter-egg-nest-small" then
        wormsToSpawn = math.random(global.Settings.eggNestSmallWormMinCount, global.Settings.eggNestSmallWormMaxCount)
    end
    if wormsToSpawn == 0 then
        return
    end

    local evolution = Utils.RoundNumberToDecimalPlaces(biterForce.evolution_factor, 3)
    local wormType = BiterSelection.GetWormType("worms", evolution)
    if wormsToSpawn == 1 then
        local xOffset = {x = Utils.GetRandomFloatInRange(0 - singleWormXRandomOffset, singleWormXRandomOffset), y = 0}
        local pos = Utils.RandomLocationInRadius(Utils.ApplyOffsetToPosition(targetPosition, xOffset), randomRadius, 0)
        surface.create_entity {name = wormType, position = pos, force = biterForce, raise_built = true}
    elseif wormsToSpawn == 2 then
        local pos = Utils.RandomLocationInRadius(Utils.ApplyOffsetToPosition(targetPosition, {x = -1, y = 0}), randomRadius, 0)
        surface.create_entity {name = wormType, position = pos, force = biterForce, raise_built = true}
        pos = Utils.RandomLocationInRadius(Utils.ApplyOffsetToPosition(targetPosition, {x = 1, y = 0}), randomRadius, 0)
        surface.create_entity {name = wormType, position = pos, force = biterForce, raise_built = true}
    else
        Logging.LogPrint("unsupported worm count for biter eggs mod: " .. wormsToSpawn)
    end
    surface.create_entity {name = eggNestType .. "-corpse", position = targetPosition, force = biterForce, raise_built = false}
end

return BiterEggs
