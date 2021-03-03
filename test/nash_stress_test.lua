-- create a canvas at 512x255 resolution
local canvas = NASH:New(512, 255)

-- this is the default setting, but let's be explicit
canvas:BlendMode(NASH.BLEND_NORMAL)

-- draw a nice vaporwave gradient
for i = 0, 255 do
    canvas:Line(0, i, 511, i, RGB(i, i-255, 255))
end

-- test some basic shapes
canvas:Line(0, 70, 511, 255, RGB(200, 200, 0))
canvas:BoxFill(40, 150, 90, 255, RGB(0, 255, 255))
canvas:Box(140, 150, 190, 255, RGB(0, 255, 255))
canvas:OvalFill(40, 80, 60, 40, RGBA(255, 255, 255))

-- blend by alpha
canvas:BlendMode(NASH.BLEND_ALPHA)

canvas:Circle(250, 60, 40, RGBA(255, 255, 255, 127))
canvas:CircleFill(350, 60, 40, RGBA(255, 255, 255, 127))
canvas:SoftCircleFill(450, 60, 80, RGBA(255, 255, 255, 127))
canvas:TriangleFill(240, 150, 290, 255, 350, 150, RGBA(0, 255, 255, 127))
canvas:Triangle(390, 150, 440, 255, 500, 150, RGBA(0, 255, 255, 127))
canvas:SoftOvalFill(120, 80, 60, 40, RGBA(255, 255, 255, 127))

-- go back to normal drawing
canvas:BlendMode(NASH.BLEND_NORMAL)

-- some random confetti
for i = 1, 256 do
    local x = math.random(0, canvas.width-1)
    local y = math.random(0, canvas.height-1)
    canvas:Point(x, y, RGB(
        math.random(0, 255),
        math.random(0, 255),
        math.random(0, 255)
    ))
end

-- text
canvas:Print("Hello, CMO Forum!", 30, 30, RGB(255, 255, 255))

-- send to special message.
-- note that the canvas can be combined with HTML tags and text.
ScenEdit_SpecialMessage("playerside", canvas:Render().."<br/>This is a test of the NASH rendering system.")