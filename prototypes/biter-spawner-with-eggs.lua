local Constants = require("constants")

data:extend(
    {
        {
            type = "simple-entity-with-force",
            name = "biter-spawner-with-eggs",
            flags = {"placeable-player", "placeable-enemy", "not-flammable", "not-repairable"},
            icon = Constants.AssetModName .. "/graphics/icon/biter-spawner-with-eggs.png",
            icon_size = 200,
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
            collision_box = {{-2, -1.1}, {2, 1.1}},
            selection_box = {{-2.3, -1.4}, {2.3, 1.4}},
            vehicle_impact_sound = {filename = "__base__/sound/car-stone-impact.ogg", volume = 1.0},
            render_layer = "object",
            picture = {
                filename = Constants.AssetModName .. "/graphics/entity/mixed-eggs-1.png",
                width = 600,
                height = 300,
                scale = 0.4
            },
            corpse = "biter-spawner-with-eggs-corpse",
            dying_explosion = "blood-explosion-big"
        }
    }
)

local function UpdateSpawnerCorpse(corpse)
    for _, animation in pairs(corpse.animation) do
        animation.layers[1].hr_version.filename = Constants.AssetModName .. "/graphics/entity/hr-spawner-die-eggs.png"
        animation.layers[1].filename = animation.layers[1].hr_version.filename
        animation.layers[1].width = animation.layers[1].hr_version.width
        animation.layers[1].height = animation.layers[1].hr_version.height
        animation.layers[1].shift = animation.layers[1].hr_version.shift
        animation.layers[1].y = animation.layers[1].hr_version.y
        animation.layers[1].scale = animation.layers[1].hr_version.scale
    end
end
UpdateSpawnerCorpse(data.raw["corpse"]["biter-spawner-corpse"])
UpdateSpawnerCorpse(data.raw["corpse"]["spitter-spawner-corpse"])
