local Constants = require("constants")

local function egg_nest_small_autoplace_settings(multiplier, order_suffix)
    local name = "enemy-egg-nest-small"
    multiplier = multiplier * tonumber(settings.startup["egg-nest-quantity"].value)
    local peak = {
        noise_layer = name,
        noise_octaves_difference = -2,
        noise_persistence = 0.9
    }
    return {
        order = "a[doodad]-a[rock]-" .. order_suffix,
        coverage = multiplier * 0.01,
        sharpness = 0.7,
        max_probability = multiplier * 0.7,
        peaks = {peak},
        force = "enemy"
    }
end

data:extend(
    {
        {
            type = "simple-entity-with-force",
            name = "biter-egg-nest-small",
            flags = {"placeable-player", "placeable-enemy", "not-flammable", "not-repairable", "placeable-off-grid"},
            icon = Constants.AssetModName .. "/graphics/icon/biter-egg-nest-small-1.png",
            icon_size = 125,
            max_health = 50,
            subgroup = "enemies",
            order = "b-b-j",
            resistances = {
                {
                    type = "fire",
                    decrease = 100,
                    percent = 100
                }
            },
            collision_box = {{-1, -0.75}, {1, 0.75}},
            selection_box = {{-1.3, -1.05}, {1.3, 1.05}},
            vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
            render_layer = "object",
            picture = {
                filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1.png",
                width = 125,
                height = 100,
                scale = 0.8
            },
            corpse = "biter-egg-nest-small-corpse",
            dying_explosion = "blood-explosion-big",
            autoplace = egg_nest_small_autoplace_settings(0.075, "b[eggs]")
        },
        {
            type = "corpse",
            name = "biter-egg-nest-small-corpse",
            flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
            icon = Constants.AssetModName .. "/graphics/icon/biter-egg-nest-small-1-corpse.png",
            icon_size = 125,
            collision_box = {{-1, -0.75}, {1, 0.75}},
            selection_box = {{-1.3, -1.05}, {1.3, 1.05}},
            selectable_in_game = false,
            time_before_removed = 15 * 60 * 60, --same as spawners
            subgroup = "corpses",
            order = "c[corpse]-b[biter-eggs]",
            final_render_layer = "remnants",
            animation = {
                {
                    width = 125,
                    height = 100,
                    scale = 0.8,
                    frame_count = 1,
                    direction_count = 1,
                    filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1-corpse.png"
                }
            }
        },
        {
            type = "noise-layer",
            name = "enemy-egg-nest-small"
        }
    }
)
