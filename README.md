# enforceGamepad
JavaScript library for unified GamePadAPI.

## Sample Build
0. Clone to the "DocumentRoot" accessible from the Web.
0. Execute the build command<br>
CoffeeScript is compiled and a JavaScript file is generated.  
The game pad library file is "enforceGamepad.js".
0. Access the directory cloned by the browser.
0. A list of values that can be acquired with this library is displayed on the screen.  
(Please operate game pad in Firefox)

## Supported Browsers
* Firefox
* Chrome
* Safari 10.2(in the future)

## How to use(CoffeeScript)
```
gamepad = new enforceGamepad()
gamepad.stat()
console.log(gamepad.controllers)
```
Information on the game pad at the time of calling the method will be returned.
```
pad = gamepad.controllers[0]
```
The above is the first connected game pad.
```
buttons = pad.buttons
axes = pad.axes
analog = pad.analog
```
With "buttons", "axes" and "analog" you can get the state of the button, the state of the four-way key, and the state of the analog stick.  
(In the XBOX360 controller, the "RT" and "LT" buttons also return analog values)

## Correspondence table
The name of the key conforms to XBOX360 controller.  
  
**Buttons**

|Button name     |Array index number|Values                 |
|:---------------|:-----------------|:---------------------:|
|A               |0                 |0 or 1                 |
|B               |1                 |0 or 1                 |
|X               |2                 |0 or 1                 |
|Y               |3                 |0 or 1                 |
|LB              |4                 |0 or 1                 |
|RB              |5                 |0 or 1                 |
|LT              |6                 |0 or 1<br>(Xbox360:0~1)|
|RT              |7                 |0 or 1<br>(Xbox360:0~1)|
|BACK            |8                 |0 or 1                 |
|START           |9                 |0 or 1                 |
|Left stick push |10                |0 or 1                 |
|Right stick push|11                |0 or 1                 |
|HOME            |12                |0 or 1                 |
In the case of a controller without the HOME button, pressing "BACK" and "START" at the same time means pressing the HOME button.

**Axes**  
The four-way controller has horizontal values for "axes[0]" and vertical values for "axes[1]".

**Analog stick**  
Likewise, the analog stick has the value of left stick in "analog[0]" and the value of right stick in "analog[1]".  
"analog[n]" contains an array of horizontal and vertical values.  
It is in the horizontal direction to "analog[n][0]", the value in the vertical direction to "analog[n][1]" between 0~1.  
