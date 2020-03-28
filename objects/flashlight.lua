Flashlight = {}

function Flashlight:new()
    self.__index = self
    return setmetatable({
        modelid = 1271, 
        max_carry = 2,
        attachment = { 
            x = 33, 
            y = -8, 
            z = 0, 
            rx = 360, 
            ry = 260, 
            rz = -110, 
            bone = "hand_l" 
        },
        usable = false,
        equipable = true,
    }, self)
end

return Flashlight