# MetaObjects - Inventory & rich object system for Onset

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
MetaObjects are always referenced by their name.

#### RegisterObject(name, meta)
Register a new metaobject by name and configuration.

```
MetaObjects.RegisterObject("mop", {
    interaction = {
        animation = { name = "WALLLEAN03" }
    },
    modelid = 1673,
    max_carry = 1,
    attachment = { x = 50, y = 40, z = -114, rx = 0, ry = -40, rz = -30, bone = "hand_r" },
    usable = false,
    equipable = true
})
```

### Pickups API

#### CreateObjectPickupNearPlayer(player, name)
Spawn metaobject pickup near a player

#### CreateObjectPickup(name, x, y, z)
Spawn metaobject at given location

### Inventory API

#### AddObjectToInventory(player, name)
Add a metaobject to a player's inventory

#### GetInventoryAvailableSlots(player)
Get number of available inventory slots for a player

#### GetInventoryCount(player, name)
Get the count for a given objects in player's inventory

#### UseObjectFromInventory(player, name)
Player uses a given metaobject.

#### EquipObjectFromInventory(player, name)
Player equips a given metaobject.

#### UnequipObject(player, name)
Player unequips a given metaobject, if equipped.

#### DropObjectFromInventory(player, name)
Remove object from player inventory and place on ground.

#### DeleteObjectFromInventory(player, name)
Remove object from player inventory.

## MetaObject Configuration

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
