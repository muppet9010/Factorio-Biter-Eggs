local BiterEggs = require("scripts/biter_eggs")

local function OnEntityDied(event)
    BiterEggs.OnEntityDied(event)
end

local function OnTick(event)
    BiterEggs.OnTick(event)
end

local function UpdateSetting(settingName)
    if settingName == "biters-per-large-egg-nest-min" or settingName == nil then
        global.Mod.Settings.eggNestLargeBiterMinCount = tonumber(settings.global["biters-per-large-egg-nest-min"].value)
    end
    if settingName == "biters-per-large-egg-nest-max" or settingName == nil then
        global.Mod.Settings.eggNestLargeBiterMaxCount = tonumber(settings.global["biters-per-large-egg-nest-max"].value)
    end
    if settingName == "biters-per-small-egg-nest-min" or settingName == nil then
        global.Mod.Settings.eggNestSmallBiterMinCount = tonumber(settings.global["biters-per-small-egg-nest-min"].value)
    end
    if settingName == "biters-per-small-egg-nest-max" or settingName == nil then
        global.Mod.Settings.eggNestSmallBiterMaxCount = tonumber(settings.global["biters-per-small-egg-nest-max"].value)
    end
end

local function CreateGlobals()
    global.Mod = global.Mod or {}
    global.Mod.enemyProbabilities = global.Mod.enemyProbabilities or {}
    global.Mod.queuedEggActions = global.Mod.queuedEggActions or {}
    global.Mod.Settings = global.Mod.Settings or {}
end

local function OnStartup()
    CreateGlobals()
    UpdateSetting(nil)
end

local function OnSettingChanged(event)
    UpdateSetting(event.setting)
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
script.on_event(defines.events.on_entity_died, OnEntityDied)
script.on_event(defines.events.on_tick, OnTick)
