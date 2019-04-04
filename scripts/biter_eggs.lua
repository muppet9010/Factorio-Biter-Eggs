local BiterEggs = {}
local Utils = require("utility/utils")

function BiterEggs.OnEntityDied(event)
    local deadEntity = event.entity
    if deadEntity.name ~= "biter-egg-nest-large" and deadEntity.name ~= "biter-egg-nest-small" then
        return
    end
    local nextTick = event.tick + 1
    global.Mod.queuedEggActions[nextTick] = global.Mod.queuedEggActions[nextTick] or {}
    table.insert(
        global.Mod.queuedEggActions[nextTick],
        {
            surface = deadEntity.surface,
            position = deadEntity.position,
            force = deadEntity.force,
            entityType = deadEntity.name
        }
    )
end

function BiterEggs.OnTick(event)
    local tick = event.tick
    local actions = global.Mod.queuedEggActions[tick]
    if actions == nil or Utils.GetTableLength(actions) == 0 then
        return
    end
    for _, eventToAction in pairs(actions) do
        BiterEggs.CreateBiters(eventToAction)
    end
    global.Mod.queuedEggActions[tick] = nil
end

function BiterEggs.CreateBiters(action)
    local surface = action.surface
    local targetPosition = action.position
    local biterForce = action.force
    local eggNestType = action.entityType

    local bitersToSpawn = 0
    if eggNestType == "biter-egg-nest-large" then
        bitersToSpawn = math.random(global.Mod.Settings.eggNestLargeBiterMinCount, global.Mod.Settings.eggNestLargeBiterMaxCount)
    elseif eggNestType == "biter-egg-nest-small" then
        bitersToSpawn = math.random(global.Mod.Settings.eggNestSmallBiterMinCount, global.Mod.Settings.eggNestSmallBiterMaxCount)
    end
    if bitersToSpawn == 0 then
        return
    end
    local spawnerTypes = {"biter-spawner", "spitter-spawner"}
    local eggSpawnerType = spawnerTypes[math.random(2)]
    local evolution = Utils.RoundNumberToDecimalPlaces(biterForce.evolution_factor, 3)
    for i = 1, bitersToSpawn do
        local biterType = Utils.GetBiterType(global.Mod.enemyProbabilities, eggSpawnerType, evolution)
        local foundPosition = surface.find_non_colliding_position(biterType, targetPosition, 0, 1)
        if foundPosition ~= nil then
            surface.create_entity {name = biterType, position = foundPosition, force = biterForce, raise_built = true}
        end
    end
end

return BiterEggs
