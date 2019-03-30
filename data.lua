local Constants = require("constants")

data:extend(
    {
        {
            type = "simple-entity-with-force",
            name = "biter-eggs",
            flags = {"placeable-player", "placeable-enemy", "not-on-map", "not-blueprintable", "not-deconstructable", "not-flammable", "not-repairable"},
            icon = Constants.AssetModName .. "/graphics/icon/mixed-eggs-1.png",
            icon_size = 242,
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
            corpse = "biter-eggs-corpse",
            dying_explosion = "blood-explosion-big"
        },
        {
            type = "corpse",
            name = "biter-eggs-corpse",
            flags = {"placeable-neutral", "placeable-off-grid", "not-on-map"},
            icon = Constants.AssetModName .. "/graphics/icon/mixed-eggs-1-corpse.png",
            icon_size = 242,
            collision_box = {{-2, -1.1}, {2, 1.1}},
            selection_box = {{-2.3, -1.4}, {2.3, 1.4}},
            selectable_in_game = false,
            time_before_removed = 15 * 60 * 60, --same as spawners
            subgroup = "corpses",
            order = "c[corpse]-b[biter-eggs]",
            final_render_layer = "remnants",
            animation = {
                {
                    width = 600,
                    height = 300,
                    scale = 0.4,
                    frame_count = 1,
                    direction_count = 1,
                    filename = Constants.AssetModName .. "/graphics/entity/mixed-eggs-1-corpse.png"
                }
            }
        }
    }
)
