function RGBA(red, green, blue, alpha)
    alpha = alpha or 255
    return {
        clip(red, 0, 255),
        clip(green, 0, 255),
        clip(blue, 0, 255),
        clip(alpha, 0, 255)
    }
end

function RGB(red, green, blue)
    return {
        clip(red, 0, 255),
        clip(green, 0, 255),
        clip(blue, 0, 255),
        0xFF
    }
end

function Color_Scale(c, scalar)
    return {
        clip(c[1]*scalar, 0, 255),
        clip(c[2]*scalar, 0, 255),
        clip(c[3]*scalar, 0, 255),
        clip(c[4]*scalar, 0, 255)
    }
end

function Color_Multiply(c0, c1)
    return {
        clip(c0[1]*c1[1], 0, 255),
        clip(c0[2]*c1[2], 0, 255),
        clip(c0[3]*c1[3], 0, 255),
        clip(c0[4]*c1[4], 0, 255)
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

