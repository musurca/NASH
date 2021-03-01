NASH = {}
NASH.__index = NASH

function NASH:New(width, height)
    local obj = {}
    setmetatable(obj, NASH)

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

function NASH:Clear(color)
    self.valid = false
    for i = 1, self.size do
        self.pixels[i] = color[(i-1)%4+1]
    end
end

function NASH:Point(x, y, color)
    x = math.floor(x)
    y = math.floor(y)
    self:Plot(x, y, color)
end

function NASH:Plot(x, y, color)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
        return
    end

    self.valid = false
    local address_start = 4*(x+y*self.width)+1
    self.pixels[address_start]   = color[1]
    self.pixels[address_start+1] = color[2]
    self.pixels[address_start+2] = color[3]
    self.pixels[address_start+3] = color[4]
end

function NASH:HorizLine(x0, y, x1, color)
    if y < 0 or y >= self.height then
        return
    end

    self.valid = false

    if x0 > x1 then
        x0, x1 = x1, x0
    end

    --clip
    x0 = clip(x0, 0, self.width-1)
    x1 = clip(x1, 0, self.width-1)

    local address_start = 4*(x0+y*self.width)+1
    for i = 0,(x1-x0) do
        self.pixels[address_start]   = color[1]
        self.pixels[address_start+1] = color[2]
        self.pixels[address_start+2] = color[3]
        self.pixels[address_start+3] = color[4]
        address_start = address_start + 4
    end
end

function NASH:Line(x0, y0, x1, y1, color)
    local dx = math.abs(x1 - x0)
    local sx = -1
    if x0 < x1 then sx = 1 end
    local dy = -math.abs(y1 - y0)
    local sy = -1
    if y0 < y1 then sy = 1 end
    local err = dx + dy
    local e2
    while true do
        self:Plot(x0, y0, color)
        if x0 == x1 and y0 == y1 then break end
        e2 = 2*err
        if e2 >= dy then
            err = err + dy
            x0 = x0 + sx
        end
        if e2 <= dx then
            err = err + dx
            y0 = y0 + sy
        end
    end
end

function NASH:Box(x0, y0, x1, y1, color)
    self:Line(x0, y0, x1, y0, color)
    self:Line(x1, y0, x1, y1, color)
    self:Line(x0, y1, x1, y1, color)
    self:Line(x0, y0, x0, y1, color)
end

function NASH:BoxFill(x0, y0, x1, y1, color)
    for y = y0, y1 do
        self:HorizLine(x0, y, x1, color)
    end
end

function NASH:Circle(x0, y0, radius, color)
    local x = 0
    local y = radius
    local d = 5 - 4 * radius
    local dA = 12
    local dB = 20 - 8 * radius
    
    while x < y do
        self:Plot(x0 + x, y0 + y, color)
        self:Plot(x0 + x, y0 - y, color)
        self:Plot(x0 - x, y0 + y, color)
        self:Plot(x0 - x, y0 - y, color)
        self:Plot(x0 + y, y0 + x, color)
        self:Plot(x0 + y, y0 - x, color)
        self:Plot(x0 - y, y0 + x, color)
        self:Plot(x0 - y, y0 - x, color)

        if d < 0 then
            d = d + dA
            dB = dB + 8
        else
            y = y - 1
            d = d + dB
            dB = dB + 16
        end 
        x = x+1
        dA = dA+8
    end
end

function NASH:CircleFill(x0, y0, radius, color)
    local x = 0
    local y = radius
    local d = 5 - 4 * radius
    local dA = 12
    local dB = 20 - 8 * radius
    
    while x < y do
        self:HorizLine(x0 - x, y0 + y, x0 + x, color)
        self:HorizLine(x0 + x, y0 - y, x0 - x, color)
        self:HorizLine(x0 + y, y0 + x, x0 - y, color)
        self:HorizLine(x0 + y, y0 - x, x0 - y, color)

        if d < 0 then
            d = d + dA
            dB = dB + 8
        else
            y = y - 1
            d = d + dB
            dB = dB + 16
        end 
        x = x+1
        dA = dA+8
    end
end

function NASH:Render(scale)
    scale = scale or 1

    if not self.valid then
        self.cached_png = PNG_Make(
            self.width, 
            self.height)
            self.cached_png:write(self.pixels)
            self.cached_base64 = base64.encode(
            table.concat(self.cached_png.output), 
            DEFAULT_ENCODER, 
            true)
            self.valid = true
    end

    local style = ""
    if scale ~= 1 then
        local s_width = scale * self.width
        local s_height = scale * self.height
        style = " width =\""..s_width.."\" height=\""..s_height.."\" "
    end

    return "<img src=\"data:image/png;base64, "..self.cached_base64.."\""..style.."/>"
end

function NASH_Test()
    local test = NASH:New(512, 255)
    
    for i = 0, 255 do
        test:HorizLine(0, i, 511, RGB(i, i-255, 255))
    end

    for i = 1, 256 do
        local x, y = math.random(0, test.width-1), math.random(0, test.height-1)
        test:Plot(x, y, {
            math.random(0, 255),
            math.random(0, 255),
            math.random(0, 255),
            255
        })
    end

    test:Line(0, 70, 511, 255, RGB(200, 200, 0))
    test:BoxFill(40, 150, 90, 255, RGB(0, 255, 255))
    test:CircleFill(450, 60, 80, RGB(255, 255, 255))

    test:Print("Hello, CMO Discord!", 30, 30, RGB(255, 255, 255))

    ScenEdit_SpecialMessage("playerside", test:Render())
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

