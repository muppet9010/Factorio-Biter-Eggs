local BiterEggs = {}
local Utils = require("utility/utils")
local Events = require("utility/events")
local EventScheduler = require("utility/event-scheduler")
local BiterSelection = require("utility/functions/biter-selection")

BiterEggs.OnLoad = function()
    Events.RegisterEvent(defines.events.on_entity_died, "EggNests", {{filter = "name", name = "biter-egg-nest-large"}, {filter = "name", name = "biter-egg-nest-small"}})
    Events.RegisterHandler(defines.events.on_entity_died, "BiterEggs.OnEntityDiedEggNests", BiterEggs.OnEntityDiedEggNests)
    EventScheduler.RegisterScheduledEventType("BiterEggs.EggPostDestroyed", BiterEggs.EggPostDestroyed)
end

BiterEggs.CreateGlobals = function()
    global.Settings = global.Settings or {}
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
    NEED to choose if to place worm, biters or nothing.
    local biterForce = event.data.force
    local evolution = Utils.RoundNumberToDecimalPlaces(biterForce.evolution_factor, 3)
    local wormType = BiterSelection.GetWormType(evolution)
    BiterEggs.CreateBiters(event)
end

BiterEggs.CreateBiters = function(event)
    local surface = event.data.surface
    local targetPosition = event.data.position
    local biterForce = event.data.force
    local eggNestType = event.data.entityType
    local attackCommandTarget = event.data.killerEntity

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
        local biterType = BiterSelection.GetBiterType(eggSpawnerType, evolution)
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

return BiterEggs
