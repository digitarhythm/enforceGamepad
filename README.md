# enforceGamePad
JavaScript library for unified GamePadAPI.

## Sample
0. Clone to the "DocumentRoot" accessible from the Web.
0. Access the directory cloned by the browser.
0. A list of values that can be acquired with this library is displayed on the screen.  
(Please operate game pad in Firefox)
  
The class library is "enforceGamepad.js".
## Supported Browsers
* Firefox
* Chrome
* Safari 10.2(in the future)

## Supported Controller
* Xbox 360 Wired Controller (STANDARD GAMEPAD Vendor: 045e Product: 028e)  
Xbox360 Wired Controller
* JC-U3613M - DirectInput Mode (Vendor: 056e Product: 2003)  
ELECOM Gaming Controller
* iBUFFALO BSGP1204P Series (Vendor: 1dd8 Product: 0010)  
iBUFFALO Gaming Controller
* 4Axes 12Key GamePad (Vendor: 0d9d Product: 3013)  
PlayStation2 Controller

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
|HOME            |0                 |0 or 1                 |
|A               |1                 |0 or 1                 |
|B               |2                 |0 or 1                 |
|X               |3                 |0 or 1                 |
|Y               |4                 |0 or 1                 |
|LB              |5                 |0 or 1                 |
|RB              |6                 |0 or 1                 |
|LT              |7                 |0 or 1<br>(Xbox360:0~1)|
|RT              |8                 |0 or 1<br>(Xbox360:0~1)|
|BACK            |9                 |0 or 1                 |
|START           |10                |0 or 1                 |
|Left stick push |11                |0 or 1                 |
|Right stick push|12                |0 or 1                 |
In the case of a controller without the HOME button, pressing "BACK" and "START" at the same time means pressing the HOME button.

**Axes**  
The four-way controller has horizontal values for "axes[0]" and vertical values for "axes[1]".

**Analog stick**  
Likewise, the analog stick has the value of left stick in "analog[0]" and the value of right stick in "analog[1]".  
"analog[n]" contains an array of horizontal and vertical values.  
It is in the horizontal direction to "analog[n][0]", the value in the vertical direction to "analog[n][1]" between 0~1.  
