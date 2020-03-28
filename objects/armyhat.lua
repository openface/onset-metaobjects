ArmyHat = {}

function ArmyHat:new()
    self.__index = self
    return setmetatable({
        modelid = 398,
        max_carry = 1,
        attachment = { 
            x = 16, 
            y = 2, 
            z = -1, 
            rx = -93, 
            ry = 9, 
            rz = -10, 
            bone = "head" 
        },
        usable = false,
        equipable = true,
    }, self)
end

return ArmyHat