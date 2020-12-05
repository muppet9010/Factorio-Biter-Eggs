local Constants = require("constants")
local Utils = require("utility/utils")

local function egg_nest_large_autoplace_settings(multiplier, order_suffix)
    local name = "enemy-egg-nest-large"
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
            name = "biter-egg-nest-large",
            enemy_map_color = {r = 0.54, g = 0.0, b = 0.0},
            flags = {"placeable-player", "placeable-enemy", "not-flammable", "not-repairable", "placeable-off-grid"},
            icon = Constants.AssetModName .. "/graphics/icon/biter-egg-nest-large-1.png",
            icon_size = 242,
            max_health = 100,
            subgroup = "enemies",
            order = "b-b-j",
            resistances = {
                {
                    type = "fire",
                    decrease = 100,
                    percent = 100
                }
            },
            collision_box = {{-2.9, -1.3}, {2.9, 1.3}},
            selection_box = {{-3.2, -1.7}, {3.2, 1.7}},
            vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
            render_layer = "object",
            picture = {
                layers = {
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-large-1.png",
                        width = 600,
                        height = 300,
                        scale = 0.6
                    }
                }
            },
            corpse = "biter-egg-nest-large-corpse",
            dying_explosion = "blood-explosion-big",
            autoplace = egg_nest_large_autoplace_settings(0.075, "b[eggs]")
        },
        {
            type = "corpse",
            name = "biter-egg-nest-large-corpse",
            flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
            icon = Constants.AssetModName .. "/graphics/icon/biter-egg-nest-large-1-corpse.png",
            icon_size = 242,
            collision_box = {{-2.9, -1.3}, {2.9, 1.3}},
            selection_box = {{-3.2, -1.7}, {3.2, 1.7}},
            selectable_in_game = false,
            time_before_removed = 15 * 60 * 60, --same as spawners
            subgroup = "corpses",
            order = "c[corpse]-b[biter-eggs]",
            final_render_layer = "remnants",
            animation = {
                layers = {
                    {
                        width = 600,
                        height = 300,
                        scale = 0.6,
                        frame_count = 1,
                        direction_count = 1,
                        filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-large-1-corpse.png"
                    }
                }
            }
        },
        {
            type = "noise-layer",
            name = "enemy-egg-nest-large"
        }
    }
)

if mods["BigWinter"] ~= nil then
    local biterEggNestLarge = data.raw["simple-entity-with-force"]["biter-egg-nest-large"]
    local biterEggNestLargeSnowLayer = Utils.DeepCopy(biterEggNestLarge.picture.layers[1])
    biterEggNestLargeSnowLayer.filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-large-1-snow-layer.png"
    table.insert(biterEggNestLarge.picture.layers, biterEggNestLargeSnowLayer)

    local biterEggNestLargeCorpse = data.raw["corpse"]["biter-egg-nest-large-corpse"]
    local biterEggNestLargeCorpseSnowLayer = Utils.DeepCopy(biterEggNestLargeCorpse.animation.layers[1])
    biterEggNestLargeCorpseSnowLayer.filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-large-1-snow-layer.png"
    table.insert(biterEggNestLargeCorpse.animation.layers, biterEggNestLargeCorpseSnowLayer)
end
