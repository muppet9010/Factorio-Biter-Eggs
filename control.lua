local BiterEggs = require("scripts/biter_eggs")
local Events = require("utility/events")
local EventScheduler = require("utility/event-scheduler")

local function UpdateSetting(settingName)
    BiterEggs.UpdateSetting(settingName)
end

local function CreateGlobals()
    BiterEggs.CreateGlobals()
end

local function OnLoad()
    BiterEggs.OnLoad()
end

local function OnStartup()
    CreateGlobals()
    UpdateSetting(nil)
    OnLoad()
end

local function OnSettingChanged(event)
    UpdateSetting(event.setting)
end

script.on_init(OnStartup)
script.on_configuration_changed(OnStartup)
script.on_load(OnLoad)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
Events.RegisterEvent(defines.events.on_entity_died, "EggNests", {{filter = "name", name = "biter-egg-nest-large"}, {filter = "name", name = "biter-egg-nest-small"}})
EventScheduler.RegisterScheduler()
