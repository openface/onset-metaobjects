Banana = {}

function Banana:new()
    self.__index = self
    return setmetatable({
        interaction = {
            sound = "eat.wav",
            animation = { name = "DRINKING" }
        },
        modelid = 1622,
        usable = true,
        equipable = false,
        max_use = 3,
        max_carry = 2,
        attachment = { 
            x = -6, 
            y = 4, 
            z = -1, 
            rx = -64, 
            ry = 1, 
            rz = 0, 
            bone = "hand_r" 
        }
    }, self)
end

return Banana