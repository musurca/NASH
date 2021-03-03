# NASH
## Graphics library for *Command: Modern Operations*

Ever wanted to draw pictures in your Special Messages? Well, now you can.

NASH (named after Modernist painter and artist of the Great War, [Paul Nash](https://en.wikipedia.org/wiki/Paul_Nash_(artist))) creates a static canvas into which you can draw text and simple shapes. This canvas is rendered as an HTML IMG tag inside your Special Message.

### API Definitions

#### `NASH:New(width, height)`
Creates a new canvas at `width` x `height` dimensions. The canvas is transparent by default, with all pixels set to `RGBA(0,0,0,0)`.
```
-- example: create a 640x480 canvas
local my_canvas = NASH:New(640, 480)

print("width: "..my_canvas.width)
print("height: "..my_canvas.height)
```

#### `RGB(red, green, blue)`
Creates an RGBA color with the elements (red, green, blue, 255).
Note that valid ranges for color elements are [0-255].
```
-- example: the color yellow
local color_yellow = RGB(255, 255, 0)
```

#### `RGBA(red, green, blue, alpha)`
Creates an RGBA color with the elements (red, green, blue, alpha).
Note that valid ranges for color elements are [0-255].
```
-- example: the semi-transparent color yellow
local color_yellow = RGBA(255, 255, 0, 127)

-- note that a color is just a table of 4 numbers. The following line is equivalent:
color_yellow = {255, 255, 0, 127}
```

#### `NASH:Clear(color)`
Fills the entire canvas with the specified `color`.
```
-- example: fill the canvas with opaque white
my_canvas:Clear( RGB(255, 255, 255) )
```

#### `NASH:Point(x, y, color)`
Draws a single point at (`x`, `y`) in the specified `color`.
```
-- example: draw a red point at (64, 32)
my_canvas:Point(64, 32, RGB(255, 0, 0) )
```

#### `NASH:Line(x0, y0, x1, y1, color)`
Draws a line from (`x0`, `y0`) to (`x1`, `y1`) in the specified `color`.
```
-- example: draw a yellow line from (0, 0) to (100, 100)
my_canvas:Line(0, 0, 100, 100, RGB(255, 255, 0) )
```

#### `NASH:Box(x0, y0, x1, y1, color)`
Draws a box from top-left (`x0`, `y0`) to bottom-right (`x1`, `y1`) in the specified `color`.
```
-- example: draw a yellow box from (0, 0) to (100, 100)
my_canvas:Box(0, 0, 100, 100, RGB(255, 255, 0) )
```

#### `NASH:BoxFill(x0, y0, x1, y1, color)`
Draws a filled box from top-left (`x0`, `y0`) to bottom-right (`x1`, `y1`) in the specified `color`.
```
-- example: draw a filled yellow box from (0, 0) to (100, 100)
my_canvas:BoxFill(0, 0, 100, 100, RGB(255, 255, 0) )
```

#### `NASH:Triangle(x0, y0, x1, y1, x2, y2 color)`
Draws a triangle with the vertices (`x0`, `y0`), (`x1`, `y1`), and (`x2`, `y2`) in the specified `color`.
```
-- example: draw a yellow triangle at (0, 0), (50, 100), (100, 0)
my_canvas:Triangle(0, 0, 50, 100, 100, 0 RGB(255, 255, 0) )
```

#### `NASH:TriangleFill(x0, y0, x1, y1, x2, y2 color)`
Draws a filled triangle with the vertices (`x0`, `y0`), (`x1`, `y1`), and (`x2`, `y2`)  in the specified `color`.
```
-- example: draw a filled yellow triangle at (0, 0), (50, 100), (100, 0)
my_canvas:TriangleFill(0, 0, 50, 100, 100, 0 RGB(255, 255, 0) )
```

#### `NASH:Circle(x0, y0, radius, color)`
Draws a circle at (`x0`, `y0`) with `radius` in the specified `color`.
```
-- example: draw a yellow circle at (50, 50) with radius 25
my_canvas:Circle(50, 50, 25, RGB(255, 255, 0) )
```

#### `NASH:CircleFill(x0, y0, radius, color)`
Draws a filled circle at (`x0`, `y0`) with `radius` in the specified `color`.
```
-- example: draw a filled yellow circle at (50, 50) with radius 25
my_canvas:Circle(50, 50, 25, RGB(255, 255, 0) )
```

#### `NASH:SoftCircleFill(x0, y0, radius, color)`
Draws a soft filled circle with Gaussian falloff at (`x0`, `y0`) with `radius` in the specified `color`.
```
-- example: draw a soft filled yellow circle at (50, 50) with radius 25
my_canvas:SoftCircleFill(50, 50, 25, RGB(255, 255, 0) )
```

#### `NASH:OvalFill(x0, y0, radius_x, radius_y, color)`
Draws a filled oval at (`x0`, `y0`) with x-dimension `radius_x` and y-dimension `radius_y` in the specified `color`.
```
-- example: draw a filled yellow oval at (50, 50) with x-radius 50 and y-radius 25
my_canvas:OvalFill(50, 50, 50, 25, RGB(255, 255, 0) )
```

#### `NASH:SoftOvalFill(x0, y0, radius_x, radius_y, color)`
Draws a soft filled oval with Gaussian falloff at (`x0`, `y0`) with x-dimension `radius_x` and y-dimension `radius_y` in the specified `color`.
```
-- example: draw a soft filled yellow oval at (50, 50) with x-radius 50 and y-radius 25
my_canvas:OvalFill(50, 50, 50, 25, RGB(255, 255, 0) )
```

#### `NASH:BlendMode(mode)`
Changes the current blend mode to `mode`. The blend modes are:
* `NASH.BLEND_NORMAL`
* `NASH.BLEND_ADD`
* `NASH.BLEND_SUBTRACT`
* `NASH.BLEND_MULTIPLY`
* `NASH.BLEND_SCREEN`
* `NASH.BLEND_ALPHA`
```
-- example: set the blend mode to NORMAL, the default mode
my_canvas:BlendMode(NASH.BLEND_NORMAL)
-- this replaces whatever is at (64, 32) with a red point
my_canvas:Point(64, 32, RGB(255, 0, 0) )

-- now we set the blend mode to ALPHA
my_canvas:BlendMode(NASH.BLEND_ALPHA)
-- this blends the point at (64, 32) with a new color, using the alpha value
my_canvas:Point(64, 32, RGBA(0, 127, 255, 127) )
```

#### `NASH:Print(str, x, y, color)`
Prints `str` at (`x`, `y`) in the specified `color`.
```
-- example: print the line 'Hello, CMO!' at (30, 30) in white
my_canvas:Print("Hello, CMO!", 30, 30, RGB(255, 255, 255))
```

#### `NASH:Invert()`
Inverts all of the elements of the canvas colors.

#### `NASH:InvertRGB()`
Inverts the RGB elements of the canvas colors, but leaves the alpha element untouched.

#### `NASH:Render()`
Renders your canvas to an HTML IMG tag for use in a Special Message. Note that NASH caches the results of each render. Once you render a canvas once, it will be much faster to render it a second time if you haven't made any changes.
```
-- example: render our canvas to a Special Message
local msg = "<br/>This is a test of the NASH rendering system."
ScenEdit_SpecialMessage("playerside", my_canvas:Render()..msg)
```

### How does this work?

NASH makes use of the display capabilities of the HTML renderer built into *Command: Modern Operations*. When rendered, the canvas is converted to a PNG image, then encoded to Base64 and injected into an IMG tag.

### Build prerequisites
* A Bash shell (on Windows 10, install the [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/))
* [luamin](https://github.com/mathiasbynens/luamin)
* [Python 3](https://www.python.org/downloads/)

#### Quick prerequisite install instructions on Windows 10

Assuming you've installed the [WSL](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) and Ubuntu, run the following commands from the shell:
```
sudo apt-get install npm
sudo npm install -g luamin
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

This will produce compiled but unminified Lua code in `debug/nash_debug.lua`. This is mostly useful to observe how the final released Lua is composed from the source files.
