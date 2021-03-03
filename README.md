# NASH
## Graphics library for *Command: Modern Operations*

Ever wanted to draw pictures in your Special Messages? Well, now you can.

NASH (named after Modernist painter and artist of the Great War, [Paul Nash](https://en.wikipedia.org/wiki/Paul_Nash_(artist))) creates a static canvas into which you can draw text and simple shapes. This canvas is rendered as an HTML IMG tag inside your Special Message.

### API Definitions

#### `NASH:New(width, height)`
Creates a new canvas at `width` x `height` dimensions.
```
-- example: create a 640x480 canvas
local my_canvas = NASH:New(640, 480)
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
