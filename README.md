# ActionObjects - Inventory / rich objects system for Onset

TODO:  This is a work in progress.


## Features

All ActiveObjects share these common functionalities:

- **Pickups** - Objects can be picked up and stored in player's inventory.
- **Inventory** - Stores finite number of items.  Objects can be used, equipped, or dropped.
- **Equipable** - Objects can configurably be equipped/unequipped.
- **Usable** - Objects can configurably be used/consumed a finite number of times.
- **Extendable** - Object files can be extended using server-side events.


## Configuration

#### modelid (int)
ModelID to use in-game and in inventory.  See full list [here](https://dev.playonset.com/wiki/Objects).

#### max_carry (integer)
Max number of these player can carry at once.

#### attachment (table)
How to attach object to the player when equipped or used.  These parameters are identical to those in the [docs](https://dev.playonset.com/wiki/SetObjectAttached).

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

### Animation Notes

Not all animations require a duration.

When animations do have a duration set, objects are automatically unequipped afterwards unless `equipped` is set to true.