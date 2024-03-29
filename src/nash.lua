NASH = {
    VERSION        = "1.02",
    BLEND_NORMAL   = 1,
    BLEND_ADD      = 2,
    BLEND_SUBTRACT = 3,
    BLEND_MULTIPLY = 4,
    BLEND_SCREEN   = 5,
    BLEND_ALPHA    = 6,
    ALIGN_LEFT     = 1,
    ALIGN_CENTER   = 2,
    ALIGN_RIGHT    = 3
}
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
    obj.blend_mode = NASH.BLEND_NORMAL
    obj.blend_funcs = {
        BlendNormal,
        BlendAdd,
        BlendSubtract,
        BlendMultiply,
        BlendScreen,
        BlendAlpha
    }
    obj.blend_alpha_funcs = {
        BlendNormal_Alpha,
        BlendAdd_Alpha,
        BlendSubtract_Alpha,
        BlendMultiply_Alpha,
        BlendScreen_Alpha,
        BlendAlpha_Alpha
    }

    return obj
end

function NASH:BlendMode(mode)
    self.blend_mode = mode
end

function NASH:Clear(color)
    self.valid = false
    for i = 1, self.size do
        self.pixels[i] = color[(i-1)%4+1]
    end
end

function NASH:Invert()
    self.valid = false
    for i = 1, self.size do
        self.pixels[i] = 255 - self.pixels[i]
    end 
end

function NASH:InvertRGB()
    self.valid = false
    for i = 1, self.size do
        if i % 4 ~= 0 then
            self.pixels[i] = 255 - self.pixels[i]
        end
    end 
end

function NASH:Point(x, y, color)
    x = math.floor(x)
    y = math.floor(y)
    self:Plot(x, y, color)
end

function NASH:SetAddressablePixel(addr, color)
    local blendFunc         = self.blend_funcs[self.blend_mode]
    local blendAlphaFunc    = self.blend_alpha_funcs[self.blend_mode]
    local a0, a1            = self.pixels[addr+3], color[4]

    self.pixels[addr]   = blendFunc(self.pixels[addr],   color[1], a0, a1)
    self.pixels[addr+1] = blendFunc(self.pixels[addr+1], color[2], a0, a1)
    self.pixels[addr+2] = blendFunc(self.pixels[addr+2], color[3], a0, a1)
    self.pixels[addr+3] = blendAlphaFunc(a0, a1)
end

function NASH:Plot(x, y, color)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
        return
    end

    self.valid = false
    self:SetAddressablePixel(4*(x+y*self.width)+1, color)
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
        self:SetAddressablePixel(address_start, color)
        address_start = address_start + 4
    end
end

function NASH:VertLine(x, y0, y1, color)
    if x < 0 or x >= self.width then
        return
    end

    self.valid = false

    if y0 > y1 then
        y0, y1 = y1, y0
    end

    --clip
    y0 = clip(y0, 0, self.height-1)
    y1 = clip(y1, 0, self.height-1)

    local address_start = 4*(x+y0*self.width)+1
    for i = 0,(y1-y0) do
        self:SetAddressablePixel(address_start, color)
        address_start = address_start + self.width*4
    end
end

function NASH:Line(x0, y0, x1, y1, color)
    x0, y0 = math.floor(x0), math.floor(y0)
    x1, y1 = math.floor(x1), math.floor(y1)

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

function NASH:Triangle(x0, y0, x1, y1, x2, y2, color)
    self:Line(x0, y0, x1, y1, color)
    self:Line(x1, y1, x2, y2, color)
    self:Line(x2, y2, x0, y0, color)
end

-- triangle fill courtesy @p01
function NASH:trapeze_h(l, r, lt, rt, y0, y1, color)
    lt, rt = (lt-l) / (y1-y0), (rt-r) / (y1-y0)
    if y0 < 0 then 
        l, r, y0 = l-y0*lt, r-y0*rt, 0 
    end
    for y0 = y0, y1 do
        self:HorizLine(math.floor(l), math.floor(y0), math.floor(r), color)
        l = l + lt
        r = r + rt
    end
end

function NASH:trapeze_w(t, b, tt, bt, x0, x1, color)
    tt, bt = (tt-t) / (x1-x0), (bt-b) / (x1-x0)
    if x0 < 0 then 
        t, b, x0 = t-x0*tt, b-x0*bt, 0 
    end
    for x0 = x0, x1 do
        self:VertLine(math.floor(x0), math.floor(t), math.floor(b), color)
        t = t + tt
        b = b + bt
    end
end

function NASH:TriangleFill(x0, y0, x1, y1, x2, y2, color)
    x0, y0 = math.floor(x0), math.floor(y0)
    x1, y1 = math.floor(x1), math.floor(y1)
    x2, y2 = math.floor(x2), math.floor(y2)
    
    local span
    if y1<y0 then 
        x0, x1, y0, y1 = x1, x0, y1, y0 
    end
    if y2<y0 then 
        x0, x2, y0, y2 = x2, x0, y2, y0 
    end
    if y2<y1 then 
        x1, x2, y1, y2 = x2, x1, y2, y1 
    end
    if math.max(x2, math.max(x1,x0)) - math.min(x2,math.min(x1,x0)) > y2-y0 then
        span = x0 + (x2-x0) / (y2-y0) * (y1-y0)
        self:trapeze_h(x0, x0, x1, span, y0, y1, color)
        self:trapeze_h(x1, span, x2, x2, y1, y2, color)
    else
        if x1<x0 then 
            x0,x1,y0,y1=x1,x0,y1,y0 
        end
        if x2<x0 then 
            x0,x2,y0,y2=x2,x0,y2,y0 
        end
        if x2<x1 then 
            x1,x2,y1,y2=x2,x1,y2,y1 
        end
        span = y0 + (y2-y0) / (x2-x0) * (x1-x0)
        self:trapeze_w(y0, y0, y1, span, x0, x1, color)
        self:trapeze_w(y1, span, y2, y2, x1, x2, color)
    end
end

function NASH:Box(x0, y0, x1, y1, color)
    if x1 < x0 then
        x1, x0 = x0, x1
    end

    self:HorizLine(x0+1, y0, x1-1, color)
    self:HorizLine(x0+1, y1, x1-1, color)
    self:VertLine(x0, y0, y1, color)
    self:VertLine(x1, y0, y1, color)
end

function NASH:BoxFill(x0, y0, x1, y1, color)
    x0, y0 = math.floor(x0), math.floor(y0)
    x1, y1 = math.floor(x1), math.floor(y1)

    for y = y0, y1 do
        self:HorizLine(x0, y, x1, color)
    end
end

function NASH:Circle(x0, y0, radius, color)
    local r = math.floor(radius)
    x0, y0 = math.floor(x0), math.floor(y0)

    local dx, dy, err = r, 0, 1-r
    while dx >= dy do
        self:Plot(x0+dx, y0+dy, color)
        self:Plot(x0-dx, y0+dy, color)
        self:Plot(x0+dx, y0-dy, color)
        self:Plot(x0-dx, y0-dy, color)
        self:Plot(x0+dy, y0+dx, color)
        self:Plot(x0-dy, y0+dx, color)
        self:Plot(x0+dy, y0-dx, color)
        self:Plot(x0-dy, y0-dx, color)

        dy = dy + 1
        
        if err < 0 then
            err = err + 2 * dy + 1
        else
            dx, err = dx-1, err + 2 * (dy - dx) + 1
        end
    end
end

function NASH:CircleFill(x0, y0, radius, color)
    local r = math.floor(radius)
    x0, y0 = math.floor(x0), math.floor(y0)

    local r_sqrd = r*r
    for i=r,1,-1 do
        local len = math.floor(math.sqrt(r_sqrd - i*i))
        self:HorizLine(x0-len, y0-i, x0+len, color)
        self:HorizLine(x0-len, y0+i, x0+len, color)
    end
    self:HorizLine(x0-r, y0, x0+r, color)
end

function NASH:OvalFill(x0, y0, radius_x, radius_y, color)
    local rx, ry = math.floor(radius_x), math.floor(radius_y)
    x0, y0 = math.floor(x0), math.floor(y0)

    local rx_sqrd, ry_sqrd = rx*rx, ry*ry
    for i=ry,1,-1 do
        local len = math.floor(math.sqrt(rx_sqrd*(1 - i*i/ry_sqrd)))
        self:HorizLine(x0-len, y0-i, x0+len, color)
        self:HorizLine(x0-len, y0+i, x0+len, color)
    end
    self:HorizLine(x0-rx, y0, x0+rx, color)
end

-- input:[-1, 1] output:[0, 1]
function GaussianApprox(x)
    return math.max((1 + math.cos(x*math.pi)) / 2, 0)
end

function NASH:SoftCircleFill(x0, y0, radius, color)
    local r = math.floor(radius)
    x0, y0 = math.floor(x0), math.floor(y0)

    local scalar, adj_color
    local r_sqrd = r*r
    for i=r,0,-1 do
        local len = math.floor(math.sqrt(r_sqrd - i*i))
        if i > 0 then
            for j=1,len do
                scalar = GaussianApprox(math.sqrt(i*i + j*j)/r)
                if scalar > 0 then
                    adj_color = Color_Scale(color, scalar)
                    self:Plot(x0+j, y0-i, adj_color)
                    self:Plot(x0-j, y0-i, adj_color)
                    self:Plot(x0+j, y0+i, adj_color)
                    self:Plot(x0-j, y0+i, adj_color)
                end
            end
            scalar = GaussianApprox(math.sqrt(i*i)/r)
            if scalar > 0 then
                adj_color = Color_Scale(color, scalar)
                self:Plot(x0, y0+i, adj_color)
                self:Plot(x0, y0-i, adj_color)
            end
        else
            for j=1,len do
                scalar = GaussianApprox(math.sqrt(i*i + j*j)/r)
                if scalar > 0 then
                    adj_color = Color_Scale(color, scalar)
                    self:Plot(x0+j, y0, adj_color)
                    self:Plot(x0-j, y0, adj_color)
                end
            end
            scalar = GaussianApprox(math.sqrt(i*i)/r)
            if scalar > 0 then
                self:Plot(x0, y0, Color_Scale(color, scalar))
            end
        end
    end
end

function NASH:SoftOvalFill(x0, y0, radius_x, radius_y, color)
    local rx, ry = math.floor(radius_x), math.floor(radius_y)
    x0, y0 = math.floor(x0), math.floor(y0)

    local scalar, adj_color
    local rx_sqrd, ry_sqrd = rx*rx, ry*ry
    for i=ry,0,-1 do
        local len = math.floor(math.sqrt(rx_sqrd*(1 - i*i/ry_sqrd)))
        if i > 0 then
            for j=1,len do
                scalar = GaussianApprox(i*i/ry_sqrd + j*j/rx_sqrd)
                if scalar > 0 then
                    adj_color = Color_Scale(color, scalar)
                    self:Plot(x0+j, y0-i, adj_color)
                    self:Plot(x0-j, y0-i, adj_color)
                    self:Plot(x0+j, y0+i, adj_color)
                    self:Plot(x0-j, y0+i, adj_color)
                end
            end
            scalar =  GaussianApprox(i*i/ry_sqrd)
            if scalar > 0 then
                adj_color = Color_Scale(color, scalar)
                self:Plot(x0, y0+i, adj_color)
                self:Plot(x0, y0-i, adj_color)
            end
        else
            for j=1,len do
                scalar = GaussianApprox(i*i/ry_sqrd + j*j/rx_sqrd)
                if scalar > 0 then
                    adj_color = Color_Scale(color, scalar)
                    self:Plot(x0+j, y0, adj_color)
                    self:Plot(x0-j, y0, adj_color)
                end
            end
            scalar = GaussianApprox(i*i/ry_sqrd)
            if scalar > 0 then
                self:Plot(x0, y0, Color_Scale(color, scalar))
            end
        end
    end
end

__NASH_COLLECTION = 0

function NASH:Render(scale)
    scale = scale or 1

    if not self.valid then
        self.cached_png = PNG_Make(
            self.width, 
            self.height
        )
        self.cached_png:write(self.pixels)
        self.cached_base64 = base64.encode(
            table.concat(self.cached_png.output), 
            DEFAULT_ENCODER, 
            true
        )
        self.valid = true
    end

    __NASH_COLLECTION = ( __NASH_COLLECTION + 1 ) % 2
    if __NASH_COLLECTION == 0 then
        -- do garbage collection every other render
        collectgarbage("collect")
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
    local canvas = NASH:New(512, 400)

    local color_black = RGB(0, 0, 0)
    local color_white = RGB(255, 255, 255)
    
    --gradient
    for i=0, canvas.width-1 do
        local intens = 255*i/(canvas.width-1)
        local color = RGB(intens, 0, 255)
        canvas:Line(i, 0, i, canvas.height-1, color)
    end
    --soft bump
    canvas:BlendMode(NASH.BLEND_ALPHA)
    canvas:SoftCircleFill(256, 200, 200, RGBA(255, 255, 255, 127) )
    
    -- text
    canvas:BlendMode(NASH.BLEND_NORMAL)
    local text = "NASH v"..NASH.VERSION
    local text_w, text_h = canvas:TextWidth(text)/2, canvas:TextHeight()
    canvas:BoxFill(256-text_w, 198, 256+text_w, 200+text_h, color_black)
    canvas:Print(text, 256, 200, color_white, NASH.ALIGN_CENTER)
    
    text = "The graphics library for COMMAND: MODERN OPERATIONS"
    text_w = canvas:TextWidth(text)/2
    canvas:BoxFill(254-text_w, 348, 258+text_w, 350+text_h, color_black)
    canvas:Print(text, 256, 350, color_white, NASH.ALIGN_CENTER )
    
    --render it to a special message
    ScenEdit_SpecialMessage("playerside", canvas:Render() )
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

