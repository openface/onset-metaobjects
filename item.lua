
function UseItem(player, name)
    EquipItem(player, name)
    SetPlayerAnimation(player, "DRINKING")

    Delay(10000, function()
        UnequipItem(player, name)
    end)
end

function EquipItem(player, name)
    local item = GetItem(name)

    local object = GetEquippedItem(player, name)
    if object ~= nil then
        print "already equipped"
        return
    end

    -- unequip whatever is in the player's bone
    local equipped_object = GetEquippedItemNameFromBone(player, item['attachment']['bone'])
    if equipped_object ~= nil then
        print "unequipping equipped"
        UnequipItem(player, equipped_object)
    end

    local x,y,z = GetPlayerLocation(player)
    local object = CreateObject(item['modelid'], x, y, z)
    SetObjectPropertyValue(object, "_name", name)
    SetObjectPropertyValue(object, "_bone", item['attachment']['bone'])
    SetObjectAttached(object, ATTACH_PLAYER, player, 
        item['attachment']['x'],
        item['attachment']['y'],
        item['attachment']['z'],
        item['attachment']['rx'],
        item['attachment']['ry'],
        item['attachment']['rz'],
        item['attachment']['bone'])

    local _equipped = GetPlayerPropertyValue(player, "_equipped")
    _equipped[name] = object
    SetPlayerPropertyValue(player, "_equipped", _equipped)
end

function UnequipItem(player, name)
    local object = GetEquippedItem(player, name)
    if object == nil then
        print "not equipped"
        return
    end

    local _equipped = GetPlayerPropertyValue(player, "_equipped")
    _equipped[name] = nil
    SetPlayerPropertyValue(player, "_equipped", _equipped)

    DestroyObject(object)
end

function GetEquippedItem(player, name)
    local _equipped = GetPlayerPropertyValue(player, "_equipped")
    return _equipped[name]
end

function GetEquippedItemNameFromBone(player, bone)
    local _equipped = GetPlayerPropertyValue(player, "_equipped")
    for _,object in pairs(_equipped) do
        if GetObjectPropertyValue(object, "_bone") == bone then
            print "found bone"
            return GetObjectPropertyValue(object, "_name")
        end
    end
    
end