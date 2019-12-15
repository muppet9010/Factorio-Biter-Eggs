local BiterEggs = {}
local Utils = require("utility/utils")
local Events = require("utility/events")
local EventScheduler = require("utility/event-scheduler")

BiterEggs.OnLoad = function()
    Events.RegisterHandler(defines.events.on_entity_died, "BiterEggs", BiterEggs.OnEntityDiedEggNests, "EggNests")
    EventScheduler.RegisterScheduledEventType("BiterEggs.CreateBiters", BiterEggs.CreateBiters)
end

BiterEggs.CreateGlobals = function()
    global.enemyProbabilities = global.enemyProbabilities or {}
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
        "BiterEggs.CreateBiters",
        deadEntity.unit_number,
        {
            surface = deadEntity.surface,
            position = deadEntity.position,
            force = deadEntity.force,
            entityType = deadEntity.name
        }
    )
end

BiterEggs.CreateBiters = function(event)
    local surface = event.data.surface
    local targetPosition = event.data.position
    local biterForce = event.data.force
    local eggNestType = event.data.entityType

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
    for i = 1, bitersToSpawn do
        local biterType = Utils.GetBiterType(global.enemyProbabilities, eggSpawnerType, evolution)
        local foundPosition = surface.find_non_colliding_position(biterType, targetPosition, 0, 1)
        if foundPosition ~= nil then
            surface.create_entity {name = biterType, position = foundPosition, force = biterForce, raise_built = true}
        end
    end
end

return BiterEggs
