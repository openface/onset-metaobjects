Chainsaw = {}

function Chainsaw:new()
    self.__index = self
    return setmetatable({
        interaction = {
            sound = "chainsaw.wav",
            animation = { name = "FISHING", duration = 4000 }
        },
        modelid = 1047,
        max_carry = 1,
        attachment = { 
            x = -20, 
            y = 5, 
            z = 22, 
            rx = 82, 
            ry = 180, 
            rz = 10, 
            bone = "hand_r" 
        },
        usable = true,
        equipable = false,
    }, self)
end

return Chainsaw