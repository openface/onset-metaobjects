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

-- add item to inventory (ignores max limit)
function AddItemToInventory(player, name)
    _inventory = GetPlayerPropertyValue(player, "_inventory")

    if GetInventoryCount(player, name) > 0 then
        -- update existing item quantity
        for k,v in pairs(_inventory) do
            if v['name'] == name then
                _inventory[k]['quantity'] = v['quantity'] + 1
                SetPlayerPropertyValue(player, "_inventory", _inventory)
                break
            end
        end
    else
        local item = GetItem(name)
        -- add new item
        table.insert(_inventory, {
            name = name,
            quantity = 1,
            used = 0
        })
        SetPlayerPropertyValue(player, "_inventory", _inventory)
    end

    print(GetPlayerName(player).." PlayerInventory: "..dump(_inventory))
end
AddFunctionExport("AddItemToInventory", AddItemToInventory)

-- get carry count for given item
function GetInventoryCount(player, name)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")
    for k,v in pairs(_inventory) do
        if v['name'] == name then
            return v['quantity']
        end
    end
    return 0
end

-- use item
function UseItemFromInventory(player, name)
    local item = GetItem(name)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")
    for k,v in pairs(_inventory) do
        if v['name'] == name then
            EquipItem(player, name)
            UseItem(player, name)

            if item['usable']['max_use'] and v['used'] < item['usable']['max_use'] then
                -- update inventory after use
                Delay(2000, function()
                    _inventory[k]['used'] = v['used'] + 1
                    SetPlayerPropertyValue(player, "_inventory", _inventory)               

                    -- delete if all used up
                    if (item['usable']['max_use'] - v['used'] == 0) then
                        print "all used up!"
                        DeleteItemFromInventory(player, name)
                    end

                    CallEvent("SyncInventory", player)
                end)
            end
        end
    end
end
AddRemoteEvent("UseItemFromInventory", UseItemFromInventory)
AddFunctionExport("UseItemFromInventory", UseItemFromInventory)

-- equip
function EquipItemFromInventory(player, name)
    EquipItem(player, name)
    CallEvent("SyncInventory", player)
end
AddRemoteEvent("EquipItemFromInventory", EquipItemFromInventory)
AddFunctionExport("EquipItemFromInventory", EquipItemFromInventory)

-- unequip
function UnequipItem(player, name)
    UnequipItem(player, name)
    CallEvent("SyncInventory", player)
end
AddRemoteEvent("UnequipItem", UnequipItem)
AddFunctionExport("UnequipItem", UnequipItem)

-- deletes from inventory and places on ground
function DropItemFromInventory(player, name)
    SetPlayerAnimation(player, "CARRY_SETDOWN")

    Delay(1000, function()
        DeleteItemFromInventory(player, name)

        -- spawn item near player
        CreateItemPickupNearPlayer(player, name)
    end)
end

-- deletes from inventory
function DeleteItemFromInventory(player, name)
    _inventory = GetPlayerPropertyValue(player, "_inventory")

    for k,v in pairs(_inventory) do
        if v['name'] == name then
            -- found item
            _qty = v['quantity'] - 1
            if _qty > 0 then
                -- decrease qty by 1
                _inventory[k]['quantity'] = _qty
            else
                -- remove item from inventory
                _inventory[k] = nil
            end
            SetPlayerPropertyValue(player, "_inventory", _inventory)

            -- unequip if dropping the last item
            if _qty == 0 then
                UnequipItem(player, name)
                return
            end

            CallEvent("SyncInventory", player)
            break
        end
    end
end
AddRemoteEvent("DropItemFromInventory", DropItemFromInventory)
AddFunctionExport("DropItemFromInventory", DropItemFromInventory)

-- get inventory data and send to client
function SyncInventory(player)
    local _inventory = GetPlayerPropertyValue(player, "_inventory")

    _send = {}
    for k,v in pairs(_inventory) do
        local item = GetItem(v['name'])           
        table.insert(_send, {
            name = v['name'],
            quantity = v['quantity'],
            modelid = item['modelid'],
            usable = (item['usable'] ~= nil),
            equipable = (item['equipable'] ~= nil),
            isequipped = (GetEquippedItem(player, v['name']) ~= nil)
        })
    end
    print(dump(_send))
    CallRemoteEvent(player, "SetInventory", json_encode(_send))
end
AddEvent("SyncInventory", SyncInventory)
AddRemoteEvent("GetInventory", SyncInventory)
