local Items = {
    ["beer"] = {
        type = "consumable",
        modelid = 662,
        inventory_max = 2,
        attachment = { x = -6, y = 6, z = -8, rx = 22, ry = -20, rz = -10, bone = "hand_r" }
    },
    ["flashlight"]  = {
        type = "wearable",
        modelid = 1271, 
        inventory_max = 2,
        attachment = { x = 33, y = -8, z = 0, rx = 360, ry = 260, rz = -110, bone = "hand_l" }
    },
    ["vest"] = {
        type = "wearable",
        modelid = 843, 
        inventory_max = 1,
        attachment = { x = -15, y = 1, z = 1, rx = -91, ry = 4, rz = 0, bone = "spine_02" }
    },
    ["armyhat"] = {
        type = "wearable",
        modelid = 398,
        inventory_max = 1,
        attachment = { x = 16, y = 2, z = -1, rx = -93, ry = 9, rz = -10, bone = "head" }
    },
    ["boxhead"] = {
        type = "wearable",
        modelid = 406,
        inventory_max = 1,
        attachment = { x = 10, y = 2, z = 0, rx = 10, ry = 90, rz = -90, bone = "head" }
    }
}

-- returns given item config
function GetItem(name)
    return Items[name]
end
