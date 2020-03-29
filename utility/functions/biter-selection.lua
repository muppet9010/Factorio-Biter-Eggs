--[[

]]
local Utils = require("utility/utils")
--local Logging = require("utility/logging")

local BiterSelection = {}

function BiterSelection.GetBiterType(spawnerType, evolution)
    global.UTILITYBITERSELECTION = global.UTILITYBITERSELECTION or {}
    global.UTILITYBITERSELECTION.enemyProbabilities = global.UTILITYBITERSELECTION.enemyProbabilities or {}
    local modEnemyProbabilities = global.UTILITYBITERSELECTION.enemyProbabilities
    if modEnemyProbabilities[spawnerType] == nil then
        modEnemyProbabilities[spawnerType] = {}
    end
    evolution = Utils.RoundNumberToDecimalPlaces(evolution, 2)
    if modEnemyProbabilities[spawnerType].calculatedEvolution == nil or modEnemyProbabilities[spawnerType].calculatedEvolution == evolution then
        modEnemyProbabilities[spawnerType].calculatedEvolution = evolution
        modEnemyProbabilities[spawnerType].probabilities = BiterSelection._CalculateSpecificBiterSelectionProbabilities(spawnerType, evolution)
    end
    return Utils.GetRandomEntryFromNormalisedDataSet(modEnemyProbabilities[spawnerType].probabilities, "chance").unit
end

function BiterSelection._CalculateSpecificBiterSelectionProbabilities(spawnerType, currentEvolution)
    local rawUnitProbs = game.entity_prototypes[spawnerType].result_units
    local currentEvolutionProbabilities = {}
    for _, possibility in pairs(rawUnitProbs) do
        local startSpawnPointIndex = nil
        for spawnPointIndex, spawnPoint in pairs(possibility.spawn_points) do
            if spawnPoint.evolution_factor <= currentEvolution then
                startSpawnPointIndex = spawnPointIndex
            end
        end
        if startSpawnPointIndex ~= nil then
            local startSpawnPoint = possibility.spawn_points[startSpawnPointIndex]
            local endSpawnPoint
            if possibility.spawn_points[startSpawnPointIndex + 1] ~= nil then
                endSpawnPoint = possibility.spawn_points[startSpawnPointIndex + 1]
            else
                endSpawnPoint = {evolution_factor = 1.0, weight = startSpawnPoint.weight}
            end

            local weight
            if startSpawnPoint.evolution_factor ~= endSpawnPoint.evolution_factor then
                local evoRange = endSpawnPoint.evolution_factor - startSpawnPoint.evolution_factor
                local weightRange = endSpawnPoint.weight - startSpawnPoint.weight
                local evoRangeMultiplier = (currentEvolution - startSpawnPoint.evolution_factor) / evoRange
                weight = (weightRange * evoRangeMultiplier) + startSpawnPoint.weight
            else
                weight = startSpawnPoint.weight
            end
            table.insert(currentEvolutionProbabilities, {chance = weight, unit = possibility.unit})
        end
    end
    local normalisedcurrentEvolutionProbabilities = Utils.NormaliseChanceList(currentEvolutionProbabilities, "chance")
    return normalisedcurrentEvolutionProbabilities
end

return BiterSelection
