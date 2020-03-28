WeedEater = {}
-- @todo fix attachment params
-- @todo need new sound
function WeedEater:new()
    self.__index = self
    return setmetatable({
        interaction = {
            sound = "chainsaw.wav",
            animation = { name = "FISHING", duration = 4000 }
        },
        modelid = 1068,
        max_carry = 1,
        attachment = { 
            x = -50, 
            y = 30, 
            z = -20, 
            rx = -40, 
            ry = 50, 
            rz = 10, 
            bone = "hand_r" 
        },
        usable = true,
        equipable = false,
    }, self)
end

return WeedEater