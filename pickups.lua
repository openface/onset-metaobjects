function CreateObjectPickup(name, x, y, z)
    local object = GetObject(name)
    print("Creating object "..name.. " modelid "..object['modelid'])

    local pickup = CreatePickup(object['modelid'], x, y, z)
    SetPickupPropertyValue(pickup, '_name', name)
    SetPickupPropertyValue(pickup, '_text', CreateText3D(name, 8, x, y, z+50, 0, 0, 0))
end
AddFunctionExport("CreateObjectPickup", CreateObjectPickup)

-- creates a new object near given player
function CreateObjectPickupNearPlayer(player, name)
    local x,y,z = GetPlayerLocation(player)
    local x,y = randomPointInCircle(x,y,100)
    CreateObjectPickup(name, x, y, z-75)
end
AddFunctionExport("CreateObjectPickupNearPlayer", CreateObjectPickupNearPlayer)

AddEvent("OnPlayerPickupHit", function(player, pickup)
    local name = GetPickupPropertyValue(pickup, '_name')
    if (name == nil) then
        return
    end

    local object = GetObject(name)
    if GetInventoryCount(player, name) >= object['max_carry'] then
        -- prevent pickup if it exceeds the max carry
        return
    end

    SetPickupPropertyValue(pickup, '_claimedby', player)
    SetPlayerAnimation(player, "PICKUP_LOWER")

    Delay(1000, function()
        -- remove pickup
        if GetPickupPropertyValue(pickup, '_claimedby') == player then
            PlaySound(player, "sounds/pickup.wav")

            AddObjectToInventory(player, name)
            DestroyText3D(GetPickupPropertyValue(pickup, '_text'))
            DestroyPickup(pickup)
        end
    end)
end)

-- spawn object by player
AddCommand("createobject", function(player, name)
    CreateObjectPickupNearPlayer(player, name)
end)

AddCommand("animate", function(player, animation)
    SetPlayerAnimation(player, "STOP")
    SetPlayerAnimation(player, string.upper(animation))
end)
