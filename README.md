# NASH
## Graphics library for *Command: Modern Operations*

[**DOWNLOAD LATEST RELEASE HERE (v1.0)**](https://github.com/musurca/NASH/releases/download/v1.0/NASH_v1.0.zip)

Ever wanted to draw pictures in your Special Messages? Well, now you can.

<p align="center"><img src="https://raw.githubusercontent.com/musurca/NASH/main/img/nash_example.jpg" /></p>

**NASH** (named after Modernist painter and artist of the Great War, [Paul Nash](https://en.wikipedia.org/wiki/Paul_Nash_(artist))) creates a static canvas into which you can draw text and simple shapes. This canvas is rendered as an HTML IMG tag inside your Special Message.

### How to install NASH into your scenario

1. Download the [latest release](https://github.com/musurca/NASH/releases/download/v1.0/NASH_v1.0.zip) and unzip it.
2. Copy the contents of the file `nash_min.lua`, paste it into the **Lua Script Editor**, and click **RUN**.
3. After a short pause, you should see the message, "NASH has been successfully installed!" This means that **NASH** has been installed persistently into your scenario, and you can now use it inside your scripts.

If you'd like to verify that **NASH** has been installed properly, open up the **Lua Script Editor** and type `NASH_Test()` in the box. (Make sure you've created at least one side in the scenario.) When you click **RUN**, you should see a test page come up in a new Special Message.

### Example usage

```
-- create a new NASH canvas at 512x400 resolution
local canvas = NASH:New(512, 400)

-- define some commonly used colors
local color_black = RGB(0, 0, 0)
local color_white = RGB(255, 255, 255)

--render a nice horizontal gradient
for i=0, canvas.width-1 do
    local intens = 255*i/(canvas.width-1)
    local color = RGB(intens, 0, 255)
    canvas:Line(i, 0, i, canvas.height-1, color)
end
--put a soft bump in the center
canvas:BlendMode(NASH.BLEND_ALPHA)
canvas:SoftCircleFill(256, 200, 200, RGBA(255, 255, 255, 127) )

-- now display some text inside a box for contrast
canvas:BlendMode(NASH.BLEND_NORMAL)
local text = "NASH v"..NASH.VERSION
local text_w, text_h = canvas:TextWidth(text)/2, canvas:TextHeight()
canvas:BoxFill(256-text_w, 198, 256+text_w, 200+text_h, color_black)
canvas:Print(text, 256, 200, color_white, NASH.ALIGN_CENTER)

text = "The graphics library for COMMAND: MODERN OPERATIONS"
text_w = canvas:TextWidth(text)/2
canvas:BoxFill(254-text_w, 348, 258+text_w, 350+text_h, color_black)
canvas:Print(text, 256, 350, color_white, NASH.ALIGN_CENTER )

--finally, render it to a special message (make sure you've created a side!)
ScenEdit_SpecialMessage("playerside", canvas:Render().."<br/>More HTML here is also okay." )
```

### How can I use it?

A full API reference of all available functions can be found [here](https://github.com/musurca/NASH/blob/main/docs/NASH_API_REFERENCE.md), and is also included as a PDF in the latest release.

### How does this work?

**NASH** makes use of the display capabilities of the HTML renderer built into *Command: Modern Operations*. When rendered, the canvas is converted to a PNG image, then encoded to Base64 and injected into an IMG tag.

### I'd like to contribute to NASH by adding new graphics functions. Where do I start?

See instructions for building **NASH** from scratch below.

### Build prerequisites
* A Bash shell (on Windows 10, install the [WSL](https://docs.microsoft.com/en-us/windows/wsl/install))
* [NPM](https://www.npmjs.com/)
* [luamin](https://github.com/mathiasbynens/luamin)
* [Python 3](https://www.python.org/downloads/)

#### Quick prerequisite install instructions on Windows 10

1. Install the WSL

Open a new PowerShell window with Administrator privileges, and run the following command:
```
wsl --install
```
When complete, restart your computer.

2. Install the prerequisites

From the Ubuntu Bash shell, run the following command:
```
sudo apt update && sudo apt-get install python3 npm && sudo npm install -g luamin
```

### How to compile

#### Release
```
./build.sh
```

The compiled, minified Lua code will be placed in `release/nash_min.lua`. This is suitable for adding to your scenario by pasting it into the Lua Code Editor and clicking RUN as the final step in the scenario creation process.
 
#### Debug
```
./build.sh debug
```

This will produce compiled but unminified Lua code in `debug/nash_debug.lua`. This is mostly useful in development for debugging.

### Acknowledgements

* [LuaBit](https://github.com/alexsilva/luabit-legacy)
* [Lua base64 encoder/decoder](https://github.com/iskolbin/lbase64
)
* [lua-pngencoder](https://github.com/wyozi/lua-pngencoder)
* [@p01](https://twitter.com/p01) (efficient triangle fill code)
