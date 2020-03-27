
-- creates a new item near given player
function CreateItemPickupNearPlayer(player, name)
    local item = GetItem(name)
    print("Creating item "..name.. " modelid "..item.modelid)

    local x,y,z = GetPlayerLocation(player)
    local x,y = randomPointInCircle(x,y,100)

    local pickup = CreatePickup(item['modelid'], x, y, z-75)
    SetPickupPropertyValue(pickup, '_name', name)
    SetPickupPropertyValue(pickup, '_text', CreateText3D(name, 8, x, y, z-25, 0, 0, 0))
end
AddFunctionExport("CreateItemPickupNearPlayer", CreateItemPickupNearPlayer)

AddEvent("OnPlayerPickupHit", function(player, pickup)
    local name = GetPickupPropertyValue(pickup, '_name')
    if (name == nil) then
        return
    end

    local item = GetItem(name)
    if GetInventoryCount(player, name) >= item['inventory_max'] then
        -- prevent pickup if it exceeds the max carry
        return
    end

    SetPickupPropertyValue(pickup, '_claimedby', player)
    SetPlayerAnimation(player, "PICKUP_LOWER")

    Delay(1000, function()
        -- remove pickup
        if GetPickupPropertyValue(pickup, '_claimedby') == player then
            PlaySound(player, "pickup.wav")

            AddItemToInventory(player, name)
            DestroyText3D(GetPickupPropertyValue(pickup, '_text'))
            DestroyPickup(pickup)
        end
    end)
end)

function PlaySound(player, sound)
    local x,y,z = GetPlayerLocation(player)
    for k,ply in pairs(GetAllPlayers()) do
        local _x,_y,_z = GetPlayerLocation(ply)
        if GetDistance3D(x, y, z, _x, _y, _z) <= 1000 then
            CallRemoteEvent(ply, "PlayItemUseSound", sound, x, y, z)
        end
    end
end

-- spawn item by player
AddCommand("createitem", function(player, name)
    CreateItemPickupNearPlayer(player, name)
end)