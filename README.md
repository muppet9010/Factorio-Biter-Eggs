# Factorio-Biter-Eggs

Adds biter egg nests to the map in addition to normal biter bases. When destroyed they will release a number of either evolution appropriate biters/spitters or worms.

![Large and Small Nests](https://thumbs.gfycat.com/WindingMeekGrouse-poster.jpg)


Mod Features
==========

- The biter egg nests can have their frequency set with a simple mod setting, ranging from rare to everywhere.
- When a biter egg nest is destroyed either biters/spitters or worms will be released based on mod chance settings. If an egg nest contains biters/spitters it is either all biters or spitters.
- The number of biters/spitters or worms is based on a configurable min/max range for the small and large biter egg nest sizes. They must be able to fit in to the area around the nest.
- All enemy types will be evolution appropriate and match the games current evolution ranges.
- Killing egg nests does not increase evolution and they only react when killed.
- Egg nests are on the enemy team and so will be targeted by turrets and players auto target fire.


Mod Compatibility
=======

- If BigWinter mod is present the egg nests have a snowy feel to them.


Events and Remote Interfaces
======

Event "BiterEggs.EggPostDestroyed"
--------------

Called when an egg nest is destroyed, but before anything is created in its place by the mod. Includes the values:

- actionName: either the value "biters", "worms" or nil if no action type has been selected based on chance.
- eggNestDetails:

    - surface: the LuaSurface of the destroyed nest
    - position: the Factorio Position of the destroyed nest
    - force: the LuaForce of the destroyed nest
    - entityType: the name of the destroyed nest, either "biter-egg-nest-large" or "biter-egg-nest-small"
    - killerEntity: the entity that killed the nest if known

Remote Interface "biter_eggs", "get_egg_post_destroyed_event_id"
------------------

Returns the event ID for the "BiterEggs.EggPostDestroyed" event.


Contributors
==========
Thanks to Hornwitser for some egg nest graphics.
