-- setup initial player inventory when player joins
AddEvent("OnPlayerJoin", function(player)
    SetPlayerPropertyValue(player, "_inventory", {})
    SetPlayerPropertyValue(player, "_equipped", {})
end)

AddEvent("OnPlayerQuit", function(player)
    cleanup(player)
end)

-- destroy any equipped objects when reloading package
AddEvent("OnPackageStop", function()
    for k,player in pairs(GetAllPlayers()) do
        cleanup(player)
    end   
end)

function cleanup(player)
    _equipped = GetPlayerPropertyValue(player, "_equipped")
    for _,o in pairs(_equipped) do 
        DestroyObject(o)
    end

    -- empty player inventory/equipped
    SetPlayerPropertyValue(player, "_inventory", {})
    SetPlayerPropertyValue(player, "_equipped", {})
end

-- add object to inventory (ignores max limit)
function AddObjectToInventory(player, name)
    _inventory = GetPlayerPropertyValue(player, "_inventory")

    if GetInventoryCount(player, name) > 0 then
        -- update existing object quantity
        for k,v in pairs(_inventory) do
            if v['name'] == name then
                _inventory[k]['quantity'] = v['quantity'] + 1
                SetPlayerPropertyValue(player, "_inventory", _inventory)
                break
            end
        end
    else
        local object = GetObject(name)
        -- add new object
        table.insert(_inventory, {
            name = name,
            quantity = 1,
            used = 0
        })
        SetPlayerPropertyValue(player, "_inventory", _inventory)
    end

    print(GetPlayerName(player).." PlayerInventory: "..dump(_inventory))
end
AddFunctionExport("AddObjectToInventory", AddObjectToInventory)

function GetInventoryAvailableSlots(player)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")
    local count = 0
    for _ in pairs(_inventory) do count = count + 1 end
    -- max slots is hardcoded at 6 (for now?)
    return (6 - count)
end
AddFunctionExport("GetInventoryAvailableSlots", GetInventoryAvailableSlots)

-- get carry count for given object
function GetInventoryCount(player, name)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")
    for k,v in pairs(_inventory) do
        if v['name'] == name then
            return v['quantity']
        end
    end
    return 0
end
AddFunctionExport("GetInventoryCount", GetInventoryCount)

-- use object
function UseObjectFromInventory(player, name)
    local object = GetObject(name)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")
    for k,v in pairs(_inventory) do
        if v['name'] == name then
            EquipObject(player, name)
            PlayInteraction(player, name)

            if object['max_use'] and v['used'] < object['max_use'] then
                -- update inventory after use
                Delay(2000, function()
                    _inventory[k]['used'] = v['used'] + 1
                    SetPlayerPropertyValue(player, "_inventory", _inventory)               

                    -- delete if all used up
                    if (object['max_use'] - v['used'] == 0) then
                        print "all used up!"
                        DeleteObjectFromInventory(player, name)
                    end

                    CallEvent("SyncInventory", player)
                end)
            end
        end
    end
end
AddRemoteEvent("UseObjectFromInventory", UseObjectFromInventory)
AddFunctionExport("UseObjectFromInventory", UseObjectFromInventory)

-- equip
function EquipObjectFromInventory(player, name)
    EquipObject(player, name)
    CallEvent("SyncInventory", player)
end
AddRemoteEvent("EquipObjectFromInventory", EquipObjectFromInventory)
AddFunctionExport("EquipObjectFromInventory", EquipObjectFromInventory)

-- unequip
function UnequipObject(player, name)
    UnequipObject(player, name)
    CallEvent("SyncInventory", player)
end
AddRemoteEvent("UnequipObject", UnequipObject)
AddFunctionExport("UnequipObject", UnequipObject)

-- deletes from inventory and places on ground
function DropObjectFromInventory(player, name)
    SetPlayerAnimation(player, "CARRY_SETDOWN")

    Delay(1000, function()
        DeleteObjectFromInventory(player, name)

        -- spawn object near player
        CreateObjectPickupNearPlayer(player, name)
    end)
end
AddRemoteEvent("DropObjectFromInventory", DropObjectFromInventory)
AddFunctionExport("DropObjectFromInventory", DropObjectFromInventory)

-- deletes from inventory
function DeleteObjectFromInventory(player, name)
    _inventory = GetPlayerPropertyValue(player, "_inventory")

    for k,v in pairs(_inventory) do
        if v['name'] == name then
            -- found object
            _qty = v['quantity'] - 1
            if _qty > 0 then
                -- decrease qty by 1
                _inventory[k]['quantity'] = _qty
            else
                -- remove object from inventory
                _inventory[k] = nil
            end
            SetPlayerPropertyValue(player, "_inventory", _inventory)

            -- unequip if dropping the last object
            if _qty == 0 then
                UnequipObject(player, name)
                return
            end

            CallEvent("SyncInventory", player)
            break
        end
    end
end
AddFunctionExport("DeleteObjectFromInventory", DeleteObjectFromInventory)

-- get inventory data and send to client
function SyncInventory(player)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")

    _send = {}
    for k,v in pairs(_inventory) do
        local object = GetObject(v['name'])           
        table.insert(_send, {
            name = v['name'],
            quantity = v['quantity'],
            modelid = object['modelid'],
            usable = object['usable'],
            equipable = object['equipable'],
            use_label = object['use_label'],
            isequipped = (GetEquippedObject(player, v['name']) ~= nil)
        })
    end
    print(dump(_send))
    CallRemoteEvent(player, "SetInventory", json_encode(_send))
end
AddEvent("SyncInventory", SyncInventory)
AddRemoteEvent("GetInventory", SyncInventory)
