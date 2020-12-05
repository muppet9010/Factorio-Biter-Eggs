local Constants = require("constants")
local Utils = require("utility/utils")

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
            enemy_map_color = {r = 0.54, g = 0.0, b = 0.0},
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
            collision_box = {{-1.45, -1.25}, {1.45, 1.25}},
            selection_box = {{-1.75, -1.55}, {1.75, 1.55}},
            vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
            render_layer = "object",
            picture = {
                layers = {
                    {
                        filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1.png",
                        width = 125,
                        height = 100,
                        scale = 1.2
                    }
                }
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
            collision_box = {{-1.45, -1.25}, {1.45, 1.25}},
            selection_box = {{-1.75, -1.55}, {1.75, 1.55}},
            selectable_in_game = false,
            time_before_removed = 15 * 60 * 60, --same as spawners
            subgroup = "corpses",
            order = "c[corpse]-b[biter-eggs]",
            final_render_layer = "remnants",
            animation = {
                layers = {
                    {
                        width = 125,
                        height = 100,
                        scale = 1.2,
                        frame_count = 1,
                        direction_count = 1,
                        filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1-corpse.png"
                    }
                }
            }
        },
        {
            type = "noise-layer",
            name = "enemy-egg-nest-small"
        }
    }
)

if mods["BigWinter"] ~= nil then
    local biterEggNestSmall = data.raw["simple-entity-with-force"]["biter-egg-nest-small"]
    local biterEggNestSmallSnowLayer = Utils.DeepCopy(biterEggNestSmall.picture.layers[1])
    biterEggNestSmallSnowLayer.filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1-snow-layer.png"
    table.insert(biterEggNestSmall.picture.layers, biterEggNestSmallSnowLayer)

    local biterEggNestSmallCorpse = data.raw["corpse"]["biter-egg-nest-small-corpse"]
    local biterEggNestSmallCorpseSnowLayer = Utils.DeepCopy(biterEggNestSmallCorpse.animation.layers[1])
    biterEggNestSmallCorpseSnowLayer.filename = Constants.AssetModName .. "/graphics/entity/biter-egg-nest-small-1-snow-layer.png"
    table.insert(biterEggNestSmallCorpse.animation.layers, biterEggNestSmallCorpseSnowLayer)
end
