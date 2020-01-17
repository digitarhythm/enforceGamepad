#============================================================================
# Gamepad Class Library
# coded by Hajime Oh-yake
#============================================================================

class enforcegamepad

  #============================================================================
  # static value
  #============================================================================
  __browser = undefined
  __ua = undefined
  __prepareflag_h = undefined
  __prepareflag_v = undefined

  #============================================================================
  # public method
  #============================================================================

  # Constructor
  constructor:->
    # get browser kind
    __ua = window.navigator.userAgent.toLowerCase()
    if (__ua.match(/.* firefox\/.*/))
      __browser = "firefox"
    else if (__ua.match(/.*version\/.* safari\/.*/))
      __browser = "safari"
    else if (__ua.match(/.*chrome\/.* safari\/.*/))
      __browser = "chrome"
    else
      __browser = "unknown"

    # controller connection event
    @controllers = []
    window.addEventListener "gamepadconnected", (e)=>
      @__addGamepad(e.gamepad)
    window.addEventListener "gamepaddisconnected", (e)=>
      @__delGamepad(e.gamepad)

    # set controller procedure definition
    @__padsmethod = []
    @__controllerProcedureDefinition()

  # loop
  stat:->
    gamepads = if (navigator.getGamepads) then navigator.getGamepads() else (if (navigator.webkitGetGamepads) then navigator.webkitGetGamepads() else [])
    for i in [0...gamepads.length]
      @controllers[i] = @__setControllerBind(gamepads[i])

  #============================================================================
  # private method
  #============================================================================

  #============================================================================
  # Add Gamepad
  #============================================================================
  __addGamepad:(gamepad)->
    @controllers[gamepad.index] = @__setControllerBind(gamepad)

  #============================================================================
  # Delete Gamepad
  #============================================================================
  __delGamepad:(gamepad)->
    @controllers[gamepad.index] = undefined

  #============================================================================
  # set controller value
  #============================================================================
  __setControllerBind:(c)->
    if (!c?)
      return

    #============================================================================
    # Distinction Gamepad
    #============================================================================
    try
      switch (__browser)
          when "firefox"
            match = c.id.match(/(.*?)-(.*?)-/)
            v = match[1]
            p = match[2]
          when "chrome"
            match = c.id.match(/.*Vendor: 0*(.*?) Product: 0*(.*?)\)/)
            v = match[1]
            p = match[2]
          when "safari"
            match = c.id.match(/(.*?)-(.*?)-/)
            v = match[1]
            p = match[2]
          else
            v = "unknown"
            p = "generic"
    catch e
      v = "unknown"
      p = "generic"

    vendor = v
    product = p

    #echo "vendor=%@, product=%@", vendor, product

    method = __browser+"_"+vendor+"_"+product
    #echo "method=%@", method

    if (typeof(@__padsmethod[method]) == 'function')
      @__padsmethod[method](c)
    else
      @__padsmethod.unknown_generic(c)

  #============================================================================
  #============================================================================
  #============================================================================
  # Controller Mapping
  #============================================================================
  #============================================================================
  #============================================================================

  #============================================================================
  # Analog Button Value Sub Procedure
  #============================================================================
  __analogButtonProc:(n, c)->
    a = c.axes
    lt = ((a[n]+1)/2).toFixed(2)
    if (lt != parseFloat(0.5).toFixed(2))
      __prepareflag_h = true
    if (!__prepareflag_h?)
      ret = parseFloat(0).toFixed(2)
    else
      ret = lt

  __crossButtonHorizontal:(n, c)->
    a = c.axes
    an = a[n].toFixed(1)
    if (an == "1.0" || an == "0.7" || an == "0.4")
      left = 1
    else
      left = 0
    if (an == "-0.1" || an == "-0.4" || an == "-0.7")
      right = 1
    else
      right = 0
    return right - left

  __crossButtonVertical:(n, c)->
    a = c.axes
    an = a[n].toFixed(1)
    if (an == "1.0" || an == "-1.0" || an == "-0.7")
      up = 1
    else
      up = 0
    if (an == "-0.1" || an == "0.1" || an == "0.4")
      down = 1
    else
      down = 0
    return down - up

  __buttonLogicalc:(n, m, c)->
    b = c.buttons
    if (b[n].value && !b[m].value)
      ret = [1, 0, 0]
    else if (!b[n].value && b[m].value)
      ret = [0, 1, 0]
    else if (b[n].value && b[m].value)
      ret = [0, 0, 1]
    else
      ret = [0, 0, 0]
    return ret

  __controllerProcedureDefinition:=>
    #============================================================================
    # Browser  :Firefox
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    @__padsmethod.firefox_45e_28e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]  = b[10].value # Home Button
      ret.buttons[1]  = b[11].value
      ret.buttons[2]  = b[12].value
      ret.buttons[3]  = b[13].value
      ret.buttons[4]  = b[14].value
      ret.buttons[5]  = b[ 8].value
      ret.buttons[6]  = b[ 9].value
      ret.buttons[7]  = @__analogButtonProc(2, c)
      ret.buttons[8]  = @__analogButtonProc(5, c)
      ret.buttons[9]  = b[ 5].value
      ret.buttons[10] = b[ 4].value
      ret.buttons[11] = b[ 6].value
      ret.buttons[12] = b[ 7].value
      ret.axes[0]     = b[3].value - b[2].value
      ret.axes[1]     = b[1].value - b[0].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[3].toFixed(2), a[4].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    @__padsmethod.chrome_45e_28e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]  = b[16].value # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = b[ 6].value.toFixed(2)
      ret.buttons[8]  = b[ 7].value.toFixed(2)
      ret.buttons[9]  = b[ 8].value
      ret.buttons[10] = b[ 9].value
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = b[15].value - b[14].value
      ret.axes[1]     = b[13].value - b[12].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    @__padsmethod.safari_45e_28e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]  = b[10].value # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = @__analogButtonProc(4, c)
      ret.buttons[8]  = @__analogButtonProc(5, c)
      ret.buttons[9]  = b[ 9].value
      ret.buttons[10] = b[ 8].value
      ret.buttons[11] = b[ 6].value
      ret.buttons[12] = b[ 7].value
      ret.axes[0]     = b[14].value - b[13].value
      ret.axes[1]     = b[12].value - b[11].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Firefox
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    @__padsmethod.firefox_56e_2003 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = b[10].value
      ret.buttons[10]  = b[11].value
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = b[16].value - b[15].value
      ret.axes[1]      = b[14].value - b[13].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    @__padsmethod.chrome_56e_2003 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = b[10].value
      ret.buttons[10]  = b[11].value
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = @__crossButtonHorizontal(9, c)
      ret.axes[1]      = @__crossButtonVertical(9, c)
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[5].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    @__padsmethod.safari_56e_2003 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = b[10].value
      ret.buttons[10]  = b[11].value
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = b[16].value - b[15].value
      ret.axes[1]      = b[14].value - b[13].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Firefox
    # Controller :56e-2004-JC-U3613M - XInput Mode
    #============================================================================
    @__padsmethod.firefox_56e_2004 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = b[10].value
      ret.buttons[10]  = b[11].value
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = b[16].value - b[15].value
      ret.axes[1]      = b[14].value - b[13].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :56e-2004-JC-U3613M - XInput Mode
    #============================================================================
    @__padsmethod.chrome_56e_2004 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[10].value # Home Button
      ret.buttons[1]   = b[ 0].value
      ret.buttons[2]   = b[ 1].value
      ret.buttons[3]   = b[ 2].value
      ret.buttons[4]   = b[ 3].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = @__analogButtonProc(2, c)
      ret.buttons[8]   = @__analogButtonProc(5, c)
      ret.buttons[9]   = b[ 9].value
      ret.buttons[10]  = b[ 8].value
      ret.buttons[11]  = b[ 6].value
      ret.buttons[12]  = b[ 7].value
      ret.axes[0]      = b[14].value - b[13].value
      ret.axes[1]      = b[12].value - b[11].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[3].toFixed(2), a[4].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :56e-2004-JC-U3613M - XInput Mode
    #============================================================================
    @__padsmethod.safari_56e_2004 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 0].value
      ret.buttons[2]   = b[ 1].value
      ret.buttons[3]   = b[ 2].value
      ret.buttons[4]   = b[ 3].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = @__analogButtonProc(4, c)
      ret.buttons[8]   = @__analogButtonProc(5, c)
      ret.buttons[9]   = b[ 9].value
      ret.buttons[10]  = b[ 8].value
      ret.buttons[11]  = b[ 6].value
      ret.buttons[12]  = b[ 7].value
      ret.axes[0]      = b[14].value - b[13].value
      ret.axes[1]      = b[12].value - b[11].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Firefox
    # Controller :56e-200e-JC-U3612M
    #============================================================================
    @__padsmethod.firefox_56e_200e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons

      ret.buttons[0]   = b[12].value # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = b[10].value
      ret.buttons[10]  = b[11].value
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = b[16].value - b[15].value
      ret.axes[1]      = b[14].value - b[13].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :56e-200e-JC-U3612T
    #============================================================================
    @__padsmethod.chrome_56e_200e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(10, 11, c)

      ret.buttons[0]   = btn[2] # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = btn[0]
      ret.buttons[10]  = btn[1]
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = @__crossButtonHorizontal(9, c)
      ret.axes[1]      = @__crossButtonVertical(9, c)
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[5].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :56e-200e-JC-U3612T
    #============================================================================
    @__padsmethod.safari_56e_200e = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(10, 11, c)

      ret.buttons[0]   = btn[2] # Home Button
      ret.buttons[1]   = b[ 2].value
      ret.buttons[2]   = b[ 3].value
      ret.buttons[3]   = b[ 0].value
      ret.buttons[4]   = b[ 1].value
      ret.buttons[5]   = b[ 4].value
      ret.buttons[6]   = b[ 5].value
      ret.buttons[7]   = b[ 6].value
      ret.buttons[8]   = b[ 7].value
      ret.buttons[9]   = btn[0]
      ret.buttons[10]  = btn[1]
      ret.buttons[11]  = b[ 8].value
      ret.buttons[12]  = b[ 9].value
      ret.axes[0]      = b[15].value - b[14].value
      ret.axes[1]      = b[13].value - b[12].value
      ret.analog[0]    = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]    = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Firefox
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    @__padsmethod.firefox_d9d_3013 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 6].value
      ret.buttons[7]  = b[ 5].value
      ret.buttons[8]  = b[ 7].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = b[15].value - b[14].value
      ret.axes[1]     = b[13].value - b[12].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    @__padsmethod.chrome_d9d_3013 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 6].value
      ret.buttons[7]  = b[ 5].value
      ret.buttons[8]  = b[ 7].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = @__crossButtonHorizontal(9, c)
      ret.axes[1]     = @__crossButtonVertical(9, c)
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[5].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    @__padsmethod.safari_d9d_3013 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 6].value
      ret.buttons[7]  = b[ 5].value
      ret.buttons[8]  = b[ 7].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = parseInt(a[2])
      ret.axes[1]     = parseInt(a[3])
      ret.analog[0]   = [a[2].toFixed(2), a[3].toFixed(2)]
      ret.analog[1]   = [a[1].toFixed(2), a[0].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Firefox
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    @__padsmethod.firefox_1dd8_10 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 2].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 3].value
      ret.buttons[4]  = b[ 0].value
      ret.buttons[5]  = b[ 6].value
      ret.buttons[6]  = b[ 7].value
      ret.buttons[7]  = b[ 4].value
      ret.buttons[8]  = b[ 5].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = b[16].value - b[15].value
      ret.axes[1]     = b[14].value - b[13].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    @__padsmethod.chrome_1dd8_10 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 2].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 3].value
      ret.buttons[4]  = b[ 0].value
      ret.buttons[5]  = b[ 6].value
      ret.buttons[6]  = b[ 7].value
      ret.buttons[7]  = b[ 4].value
      ret.buttons[8]  = b[ 5].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = @__crossButtonHorizontal(9, c)
      ret.axes[1]     = @__crossButtonVertical(9, c)
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[5].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    @__padsmethod.safari_1dd8_10 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 2].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 3].value
      ret.buttons[4]  = b[ 0].value
      ret.buttons[5]  = b[ 6].value
      ret.buttons[6]  = b[ 7].value
      ret.buttons[7]  = b[ 4].value
      ret.buttons[8]  = b[ 5].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = parseInt(a[0])
      ret.axes[1]     = parseInt(a[1])
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :8BitDo N30 Pro 2 (STANDARD GAMEPAD Vendor: 045e Product: 02e0)
    #============================================================================
    @__padsmethod.chrome_45e_2e0 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = b[ 6].value
      ret.buttons[8]  = b[ 7].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = b[15].value - b[14].value
      ret.axes[1]     = b[13].value - b[12].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :8BitDo N30 Pro 2 (STANDARD GAMEPAD Vendor: 045e Product: 02e0)
    #============================================================================
    @__padsmethod.safari_45e_2e0 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = @__analogButtonProc(4, c)
      ret.buttons[8]  = @__analogButtonProc(5, c)
      ret.buttons[9]  = b[ 6].value
      ret.buttons[10] = b[ 7].value
      ret.buttons[11] = b[ 8].value
      ret.buttons[12] = b[ 9].value
      ret.axes[0]     = b[13].value - b[12].value
      ret.axes[1]     = b[11].value - b[10].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller : 2dc8-2865-8BitDo N30 Pro 2(Direct Input)
    #============================================================================
    @__padsmethod.chrome_2dc8_2865 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(10, 11, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 1].value
      ret.buttons[2]  = b[ 0].value
      ret.buttons[3]  = b[ 4].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 6].value
      ret.buttons[6]  = b[ 7].value
      ret.buttons[7]  = b[ 8].value
      ret.buttons[8]  = b[ 9].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[13].value
      ret.buttons[12] = b[14].value
      ret.axes[0]     = @__crossButtonHorizontal(9, c)
      ret.axes[1]     = @__crossButtonVertical(9, c)
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[5].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller : 2dc8-2865-8BitDo N30 Pro 2(Direct Input)
    #============================================================================
    @__padsmethod.safari_2dc8_2865 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(10, 11, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 1].value
      ret.buttons[2]  = b[ 0].value
      ret.buttons[3]  = b[ 4].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 6].value
      ret.buttons[6]  = b[ 7].value
      ret.buttons[7]  = b[ 8].value
      ret.buttons[8]  = b[ 9].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[13].value
      ret.buttons[12] = b[14].value
      ret.axes[0]     = b[19].value - b[18].value
      ret.axes[1]     = b[17].value - b[16].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Chrome
    # Controller :8BitDo N30 Pro 2 (STANDARD GAMEPAD Vendor: 045e Product: 02e0)
    #============================================================================
    @__padsmethod.chrome_45e_2e0 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = b[ 6].value
      ret.buttons[8]  = b[ 7].value
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value
      ret.buttons[12] = b[11].value
      ret.axes[0]     = b[15].value - b[14].value
      ret.axes[1]     = b[13].value - b[12].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :Safari
    # Controller :8BitDo N30 Pro 2 (STANDARD GAMEPAD Vendor: 045e Product: 02e0)
    #============================================================================
    @__padsmethod.safari_45e_2e0 = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(8, 9, c)

      ret.buttons[0]  = btn[2] # Home Button
      ret.buttons[1]  = b[ 0].value
      ret.buttons[2]  = b[ 1].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = @__analogButtonProc(4, c)
      ret.buttons[8]  = @__analogButtonProc(5, c)
      ret.buttons[9]  = b[ 6].value
      ret.buttons[10] = b[ 7].value
      ret.buttons[11] = b[ 8].value
      ret.buttons[12] = b[ 9].value
      ret.axes[0]     = b[13].value - b[12].value
      ret.axes[1]     = b[11].value - b[10].value
      ret.analog[0]   = [a[0].toFixed(2), a[1].toFixed(2)]
      ret.analog[1]   = [a[2].toFixed(2), a[3].toFixed(2)]

      return ret

    #============================================================================
    # Browser  :All
    # Controller :Generic
    #============================================================================
    @__padsmethod.unknown_generic = (c)=>
      ret = []
      ret.id = c.id
      ret.buttons = []
      ret.axes = [[], []]
      ret.analog = [[], []]

      a = c.axes
      b = c.buttons
      btn = @__buttonLogicalc(6, 7, c)

      ret.buttons[0] = btn[2] # Home Button
      ret.buttons[1]  = b[ 1].value
      ret.buttons[2]  = b[ 0].value
      ret.buttons[3]  = b[ 2].value
      ret.buttons[4]  = b[ 3].value
      ret.buttons[5]  = b[ 4].value
      ret.buttons[6]  = b[ 5].value
      ret.buttons[7]  = 0
      ret.buttons[8]  = 0
      ret.buttons[9]  = btn[0]
      ret.buttons[10] = btn[1]
      ret.buttons[11] = b[10].value if (b[10]?)
      ret.buttons[12] = b[11].value if (b[11]?)
      ret.axes[0]     = parseInt(a[0])
      ret.axes[1]     = parseInt(a[1])
      ret.analog[0]   = 0
      ret.analog[1]   = 0

      return ret

