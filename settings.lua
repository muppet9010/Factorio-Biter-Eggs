data:extend(
    {
        {
            name = "egg-nest-quantity",
            type = "double-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 100,
            setting_type = "startup",
            order = "1000"
        },
        {
            name = "biters-per-large-egg-nest-min",
            type = "int-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 20,
            setting_type = "runtime-global",
            order = "1000"
        },
        {
            name = "biters-per-large-egg-nest-max",
            type = "int-setting",
            default_value = 4,
            minimum_value = 0,
            maximum_value = 20,
            setting_type = "runtime-global",
            order = "1001"
        },
        {
            name = "biters-per-small-egg-nest-min",
            type = "int-setting",
            default_value = 0,
            minimum_value = 0,
            maximum_value = 10,
            setting_type = "runtime-global",
            order = "1002"
        },
        {
            name = "biters-per-small-egg-nest-max",
            type = "int-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 10,
            setting_type = "runtime-global",
            order = "1003"
        }
    }
)
