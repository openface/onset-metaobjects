local Items = {
    ["beer"] = {
        usable = {
            max_use = 3,
            sound = "drink.wav",
            animation = "DRINKING"
        },
        modelid = 662,
        max_carry = 2,
        attachment = { x = -6, y = 6, z = -8, rx = 22, ry = -20, rz = -10, bone = "hand_r" }
    },
    ["flashlight"]  = {
        equipable = {},
        modelid = 1271, 
        max_carry = 2,
        attachment = { x = 33, y = -8, z = 0, rx = 360, ry = 260, rz = -110, bone = "hand_l" }
    },
    ["vest"] = {
        equipable = {
            sound = "backpack.wav",
            animation = "CHECK_EQUIPMENT"
        },
        modelid = 843, 
        max_carry = 1,
        attachment = { x = -15, y = 1, z = 1, rx = -91, ry = 4, rz = 0, bone = "spine_02" }
    },
    ["armyhat"] = {
        equipable = {},
        modelid = 398,
        max_carry = 1,
        attachment = { x = 16, y = 2, z = -1, rx = -93, ry = 9, rz = -10, bone = "head" }
    },
    ["boxhead"] = {
        equipable = {},
        modelid = 406,
        max_carry = 1,
        attachment = { x = 10, y = 2, z = 0, rx = 10, ry = 90, rz = -90, bone = "head" }
    },
    ["chainsaw"] = {
        equipable = {},
        modelid = 1047,
        max_carry = 1,
        attachment = { x = -20, y = 5, z = 22, rx = 82, ry = 180, rz = 10, bone = "hand_r" }
    }
}

-- returns given item config
function GetItem(name)
    return Items[name]
end
