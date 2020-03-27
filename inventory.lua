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
        -- add new item
        table.insert(_inventory, {
            name = name,
            quantity = 1,
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
    -- equip before use
    UseItem(player, name)
    CallEvent("SyncInventory", player)
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


-- drop item
function DropItemFromInventory(player, name)
    print("dropping item "..name)
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

            SetPlayerAnimation(player, "CARRY_SETDOWN")

            Delay(1000, function()
                -- unequip if dropping the last item
                if _qty == 0 then
                    UnequipItem(player, name)
                end

                -- spawn item near player
                CreateItemPickupNearPlayer(player, name)
            end)

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
            type = item['type'],
            isequipped = (GetEquippedItem(player, v['name']) ~= nil)
        })
    end
    CallRemoteEvent(player, "SetInventory", json_encode(_send))
end
AddEvent("SyncInventory", SyncInventory)
AddRemoteEvent("GetInventory", SyncInventory)
