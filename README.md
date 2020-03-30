# Onset MetaObjects - Inventory / rich objects system for Onset

NOTE:  This is a work in progress, not yet ready for use.

## Features

All MetaObjects share these common functionalities:

- **Pickups** - Objects can be picked up and stored in player's inventory.
- **Inventory** - Stores finite number of items.  Objects can be used, equipped, or dropped.
- **Equipable** - Objects can configurably be equipped/unequipped.
- **Usable** - Objects can configurably be used/consumed a finite number of times.
- **Extendable** - Object files can be extended using server-side events.

Note: Hold the [I] key to bring up the inventory menu.

## How To Use

The MetaObjects package is intended to work along with other packages.  To include it
your server, add it to the packages section in the server configuration file.  (Eg. `server_config.json`)

Import it from a server-side script:

```
MetaObjects = ImportPackage("metaobjects")
```

## Exported API Functions

Once this package is imported, you can use it's exported functions in your server-side scripts.

To add an object to a player's inventory:

```
MetaObjects.AddObjectToInventory(player, "beer")
```

To spawn an object pickup near a player:

```
MetaObjects.CreateObjectPickupNearPlayer(player, 'banana')
```

TODO: document all exported functions


## Configuration

#### modelid (int)
ModelID to use in-game and in inventory.  See full list [here](https://dev.playonset.com/wiki/Objects).

#### max_carry (integer)
Max number of these player can carry at once.

#### attachment (table)
How to attach object to the player when equipped or used.  These parameters are similar to those in [SetObjectAttached](https://dev.playonset.com/wiki/SetObjectAttached).

```
attachment = { 
    x = -20, 
    y = 5, 
    z = 22, 
    rx = 82, 
    ry = 180, 
    rz = 10, 
    bone = "hand_r" 
},
```

#### usable (boolean)
Whether or not this object can used directly from the inventory.

#### max_use (integer)
Max number of times this object can be used (if usable).  The object is discarded after this limit is exceeded.

#### equipable (boolean)
Whether or not this object can be equipped directly from the inventory. 

#### interaction (table)
Play animation and sounds when equipping or using an item.  See [AnimationList](https://dev.playonset.com/wiki/AnimationList).  Sounds are rendered in 3D from the player to all nearby clients within 1000 units.

```
interaction = {
    sound = "sounds/chainsaw.wav",
    animation = { name = "FISHING", duration = 4000 }
},
```

Note: Not all animations require a duration.  Animations are cancelled when the player
unequips the object.

## TODO

- [ ] Auto-equip when picked up when configured
- [ ] Unequip any equipped weapon when equipping an object
- [ ] Add armor bonus to vest object
- [ ] Consider ExtendObject, similar to RegisterObject, but allows overrides
