RegisterObject("vest", {
    interaction = {
        sound = "sounds/backpack.wav",
        animation = { name = "CHECK_EQUIPMENT" }
    },
    modelid = 843, 
    max_carry = 1,
    attachment = { 
        x = -15, 
        y = 1, 
        z = 1, 
        rx = -91, 
        ry = 4, 
        rz = 0, 
        bone = "spine_02" 
    },
    usable = false,
    equipable = true
})
