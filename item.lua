
function UseItem(player, name)
    local item = GetItem(name)
    if item['usable'] == nil then
        return
    end

    if item['usable']['animation'] then
        PlayAnimation(player, item['usable']['animation'])
    end

    if item['usable']['sound'] then
        PlaySound(player, item['usable']['sound'])
    end
    
    --Delay(10000, function()
    --    UnequipItem(player, name)
    --end)
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

    if item['equipable'] then
        if item['equipable']['animation'] then
            PlayAnimation(player, item['equipable']['animation'])
        end
        if item['equipable']['sound'] then
            PlaySound(player, item['equipable']['sound'])
        end
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
    print "unequipping"
    local object = GetEquippedItem(player, name)
    if object == nil then
        print "not equipped"
        return
    end

    -- remove from equipped list
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

function PlaySound(player, sound)
    local x,y,z = GetPlayerLocation(player)
    for k,ply in pairs(GetAllPlayers()) do
        local _x,_y,_z = GetPlayerLocation(ply)
        if GetDistance3D(x, y, z, _x, _y, _z) <= 1000 then
            CallRemoteEvent(ply, "PlayItemUseSound", sound, x, y, z)
        end
    end
end

function PlayAnimation(player, animation)
    print(dump(animation))
    SetPlayerAnimation(player, animation['name'])
    if animation['duration'] then
        Delay(animation['duration'], function()
            SetPlayerAnimation(player, "STOP")
        end)
    end
end