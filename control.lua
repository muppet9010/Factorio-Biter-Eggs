local BiterEggs = require("scripts/biter_eggs")
local EventScheduler = require("utility/event-scheduler")

local function UpdateSetting(settingName)
    BiterEggs.UpdateSetting(settingName)
end

local function CreateGlobals()
    BiterEggs.CreateGlobals()
end

local function OnLoad()
    --Any Remote Interface registration calls can go in here or in root of control.lua
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
EventScheduler.RegisterScheduler()
