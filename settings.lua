data:extend(
    {
        {
            name = "egg-nest-quantity",
            type = "double-setting",
            default_value = 1,
            minimum_value = 0,
            maximum_value = 100,
            setting_type = "startup",
            order = "1000"
        },
        {
            name = "biters-per-egg-nest",
            type = "int-setting",
            default_value = 3,
            minimum_value = 0,
            maximum_value = 10,
            setting_type = "runtime-global",
            order = "1000"
        }
    }
)
