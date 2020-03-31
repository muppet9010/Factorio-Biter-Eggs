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
        }
    }
)

data:extend(
    {
        {
            name = "egg-nest-biter-chance",
            type = "double-setting",
            default_value = 0.7,
            minimum_value = 0,
            maximum_value = 1,
            setting_type = "runtime-global",
            order = "1000"
        },
        {
            name = "egg-nest-worm-chance",
            type = "double-setting",
            default_value = 0.3,
            minimum_value = 0,
            maximum_value = 1,
            setting_type = "runtime-global",
            order = "1001"
        },
        {
            name = "biters-per-large-egg-nest-min",
            type = "int-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 20,
            setting_type = "runtime-global",
            order = "1100"
        },
        {
            name = "biters-per-large-egg-nest-max",
            type = "int-setting",
            default_value = 4,
            minimum_value = 0,
            maximum_value = 20,
            setting_type = "runtime-global",
            order = "1101"
        },
        {
            name = "biters-per-small-egg-nest-min",
            type = "int-setting",
            default_value = 0,
            minimum_value = 0,
            maximum_value = 10,
            setting_type = "runtime-global",
            order = "1102"
        },
        {
            name = "biters-per-small-egg-nest-max",
            type = "int-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 10,
            setting_type = "runtime-global",
            order = "1103"
        },
        {
            name = "worms-per-large-egg-nest-min",
            type = "int-setting",
            default_value = 1,
            minimum_value = 0,
            maximum_value = 3,
            setting_type = "runtime-global",
            order = "1201"
        },
        {
            name = "worms-per-large-egg-nest-max",
            type = "int-setting",
            default_value = 2,
            minimum_value = 0,
            maximum_value = 2,
            setting_type = "runtime-global",
            order = "1201"
        },
        {
            name = "worms-per-small-egg-nest-min",
            type = "int-setting",
            default_value = 0,
            minimum_value = 0,
            maximum_value = 1,
            setting_type = "runtime-global",
            order = "1202"
        },
        {
            name = "worms-per-small-egg-nest-max",
            type = "int-setting",
            default_value = 1,
            minimum_value = 0,
            maximum_value = 1,
            setting_type = "runtime-global",
            order = "1203"
        }
    }
)
