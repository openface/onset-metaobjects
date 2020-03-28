Beer = {}

function Beer:new()
    self.__index = self
    return setmetatable({
        interaction = {
            sound = "drink.wav",
            animation = { name = "DRINKING" }
        },
        modelid = 662,
        usable = true,
        equipable = false,
        max_use = 3,
        max_carry = 2,
        attachment = { 
            x = -6, 
            y = 6, 
            z = -8, 
            rx = 22, 
            ry = -20, 
            rz = -10, 
            bone = "hand_r" 
        }
    }, self)
end

return Beer