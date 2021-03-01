function NASH_New(width, height)
    local obj = {}
    obj.width = width
    obj.height = height
    obj.size = width*height*4
    obj.pixels = {}

    for i = 1, obj.size do
        obj.pixels[i] = 0
    end

    obj.valid = false
    obj.cached_png = nil
    obj.cached_base64 = nil

    return obj
end

function NASH_Fill(nash_obj, color)
    nash_obj.valid = false
    for i = 1, nash_obj.size do
        nash_obj.pixels[i] = color[(i-1)%4+1]
    end
end

function NASH_Plot(nash_obj, x, y, color)
    nash_obj.valid = false
    local address_start = 4*(x+y*nash_obj.width)+1
    nash_obj.pixels[address_start]   = color[1]
    nash_obj.pixels[address_start+1] = color[2]
    nash_obj.pixels[address_start+2] = color[3]
    nash_obj.pixels[address_start+3] = color[4]
end

function NASH_Render(nash_obj, scale)
    scale = scale or 1

    if not nash_obj.valid then
        nash_obj.cached_png = PNG_Make(
            nash_obj.width, 
            nash_obj.height)
        nash_obj.cached_png:write(nash_obj.pixels)
        nash_obj.cached_base64 = base64.encode(
            table.concat(nash_obj.cached_png.output), 
            DEFAULT_ENCODER, 
            true)
        nash_obj.valid = true
    end

    local s_width = scale * nash_obj.width
    local s_height = scale * nash_obj.height
    local style = " width =\""..s_width.."\" height=\""..s_height.."\" "

    return "<img src=\"data:image/png;base64, "..nash_obj.cached_base64.."\""..style.."/>"
end

function NASH_Test()
    local test = NASH_New(64, 64)
    --NASH_Fill(test, {255, 0, 255, 255})
    for i = 1, 64 do
        local x, y = math.random(0, 63), math.random(0, 63)
        NASH_Plot(test, x, y, {
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255),
            255
        })
    end
    ScenEdit_SpecialMessage("playerside", NASH_Render(test, 4))
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

