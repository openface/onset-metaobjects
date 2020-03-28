Headphones = {}

function Headphones:new()
    self.__index = self
    return setmetatable({
        modelid = 828,
        max_carry = 1,
        attachment = { 
            x = 11, 
            y = -3, 
            z = -1, 
            rx = -6, 
            ry = -92, 
            rz = 100, 
            bone = "head" 
        },
        usable = false,
        equipable = true,
    }, self)
end

return Headphones