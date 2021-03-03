function BlendNormal(c0, c1, a0, a1)
    return c1
end

function BlendNormal_Alpha(a0, a1)
    return a1
end

function BlendAdd(c0, c1, a0, a1)
    return clip(c0+c1, 0, 255)
end

function BlendAdd_Alpha(a0, a1)
    return clip(a0+a1, 0, 255)
end

function BlendSubtract(c0, c1, a0, a1)
    return clip(c0-c1, 0, 255)
end

function BlendSubtract_Alpha(a0, a1)
    return clip(a0-a1, 0, 255)
end

function BlendMultiply(c0, c1, a0, a1)
    return clip(c0*c1/255, 0, 255)
end

function BlendMultiply_Alpha(a0, a1)
    return clip(a0*a1/255, 0, 255)
end

function BlendScreen(c0, c1, a0, a1)
    return clip(255 - (255-c0)*(255-c1)/255, 0, 255)
end

function BlendScreen_Alpha(a0, a1)
    return clip(255 - (255-a0)*(255-a1)/255, 0, 255)
end

function BlendAlpha(c0, c1, a0, a1)
    local alpha0, alpha1 = a0/255, a1/255
    local over = ( c1*(alpha1) + c0*(alpha0)*(1-alpha1) ) / ( alpha1 + alpha0*(1-alpha1) )

    return clip(over, 0, 255)
end

function BlendAlpha_Alpha(a0, a1)
    local alpha0, alpha1 = a0/255, a1/255

    return clip(255*(alpha1 + alpha0*(1-alpha1)), 0, 255)
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

