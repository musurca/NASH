function RGBA(red, green, blue, alpha)
    alpha = alpha or 255
    return {
        red,
        green,
        blue,
        alpha
    }
end

function RGB(red, green, blue)
    return {
        red,
        green,
        blue,
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

