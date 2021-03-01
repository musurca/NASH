function RGBA(red, green, blue, alpha)
    alpha = alpha or 255
    return {
        clip(math.floor(red), 0, 255),
        clip(math.floor(green), 0, 255),
        clip(math.floor(blue), 0, 255),
        clip(math.floor(alpha), 0, 255)
    }
end

function RGB(red, green, blue)
    return {
        clip(math.floor(red), 0, 255),
        clip(math.floor(green), 0, 255),
        clip(math.floor(blue), 0, 255),
        0xFF
    }
end

function Color_Copy(c)
    return {
        c[1],
        c[2],
        c[3],
        c[4]
    }
end

function Color_Clear()
    return RGBA(0,0,0,0)
end

function Color_Black()
    return RGB(0,0,0)
end

function Color_White()
    return RGBA(255,255,255)
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

