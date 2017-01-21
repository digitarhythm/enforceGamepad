#============================================================================
# enforce Gamepad Class Library
# coded by Hajime Oh-yake
#
# ver 0.1 2017.01.15
# ver 0.2 2017.01.21
#============================================================================

class enforceGamepad

    __padsmethod = []
    __browser = undefined
    __prepareflag_h = undefined
    __prepareflag_v = undefined

#============================================================================
# public method
#============================================================================

    # Constructor
    constructor:->
        # ブラウザ分類
        _ua = window.navigator.userAgent.toLowerCase()
        if (_ua.match(/.* firefox\/.*/))
            __browser = "firefox"
        else if (_ua.match(/.*version\/.* safari\/.*/))
            __browser = "safari"
        else if (_ua.match(/.*chrome\/.* safari\/.*/))
            __browser = "chrome"
        else
            _browser = "unknown"

        # コントローラー接続イベント
        @controllers = []
        window.addEventListener "gamepadconnected", (e)=>
            @__addGamepad(e.gamepad)
        window.addEventListener "gamepaddisconnected", (e)=>
            @__delGamepad(e.gamepad)

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
        gamepad.axes[2] = undefined
        gamepad.axes[5] = undefined
        @controllers[gamepad.index] = @__setControllerBind(gamepad)

    #============================================================================
    # Delete Gamepad
    #============================================================================
    __delGamepad:(gamepad)->
        @controllers[gamepad.index] = undefined

    #============================================================================
    # Distinction Gamepad
    #============================================================================
    __distinction:(id)->
        switch (__browser)
            when "firefox"
                match = id.match(/(.*?)-(.*?)-/)
                vendor = match[1]
                product = match[2]
            when "chrome"
                match = id.match(/.*Vendor: 0*(.*?) Product: 0*(.*?)\)/)
                vendor = match[1]
                product = match[2]
            when "safari"
                match = id.match(/(.*?)-(.*?)-/)
                vendor = match[1]
                product = match[2]
        return {'vendor':vendor, 'product':product}

    #============================================================================
    # set controller value
    #============================================================================
    __setControllerBind:(c)->
        if (!c?)
            return

        cont = @__distinction(c.id)
        vendor = cont.vendor
        product = cont.product

        method = __browser+"_"+vendor+"_"+product
        if (typeof(__padsmethod[method]) == 'function')
            __padsmethod[method](c)
        else
            @generic_controller(c)

    #============================================================================
    #============================================================================
    #============================================================================
    # Controller Mapping
    #============================================================================
    #============================================================================
    #============================================================================


    #============================================================================
    # Browser    :Firefox
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    __padsmethod.firefox_45e_28e = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]      = b[11].value
        ret.buttons[1]      = b[12].value
        ret.buttons[2]      = b[13].value
        ret.buttons[3]      = b[14].value
        ret.buttons[4]      = b[ 8].value
        ret.buttons[5]      = b[ 9].value
        lt = ((a[2]+1)/2).toFixed(2)
        if (lt != parseFloat(0.5).toFixed(2))
            __prepareflag_h = true
        if (!__prepareflag_h?)
            ret.buttons[6]  = parseFloat(0).toFixed(2)
        else
            ret.buttons[6]  = lt
        rt = ((a[5]+1)/2).toFixed(2)
        if (rt != parseFloat(0.5).toFixed(2))
            __prepareflag_v = true
        if (!__prepareflag_v?)
            ret.buttons[7]  = parseFloat(0).toFixed(2)
        else
            ret.buttons[7]  = rt
        ret.buttons[8]      = b[ 5].value
        ret.buttons[9]      = b[ 4].value
        ret.buttons[10]     = b[ 6].value
        ret.buttons[11]     = b[ 7].value
        ret.buttons[12]     = b[10].value
        ret.axes[0]         = b[3].value - b[2].value
        ret.axes[1]         = b[1].value - b[0].value
        ret.analog[0]       = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]       = [a[3].toFixed(2), a[4].toFixed(2)]

        return ret


    #============================================================================
    # Browser    :Chrome
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    __padsmethod.chrome_45e_28e = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]      = b[ 0].value
        ret.buttons[1]      = b[ 1].value
        ret.buttons[2]      = b[ 2].value
        ret.buttons[3]      = b[ 3].value
        ret.buttons[4]      = b[ 4].value
        ret.buttons[5]      = b[ 5].value
        ret.buttons[6]      = b[ 6].value.toFixed(2)
        ret.buttons[7]      = b[ 7].value.toFixed(2)
        ret.buttons[8]      = b[ 8].value
        ret.buttons[9]      = b[ 9].value
        ret.buttons[10]     = b[10].value
        ret.buttons[11]     = b[11].value
        ret.buttons[12]     = b[16].value
        ret.axes[0]         = b[15].value - b[14].value
        ret.axes[1]         = b[13].value - b[12].value
        ret.analog[0]       = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]       = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Safari
    # Controller :Xbox 360 Wired Controller
    #============================================================================
    __padsmethod.safari_45e_28e = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]      = b[ 0].value
        ret.buttons[1]      = b[ 1].value
        ret.buttons[2]      = b[ 2].value
        ret.buttons[3]      = b[ 3].value
        ret.buttons[4]      = b[ 4].value
        ret.buttons[5]      = b[ 5].value
        lt = ((a[4]+1)/2).toFixed(2)
        if (lt != parseFloat(0.5).toFixed(2))
            __prepareflag_h = true
        if (!__prepareflag_h?)
            ret.buttons[6]  = parseFloat(0).toFixed(2)
        else
            ret.buttons[6]  = lt
        rt = ((a[5]+1)/2).toFixed(2)
        if (rt != parseFloat(0.5).toFixed(2))
            __prepareflag_v = true
        if (!__prepareflag_v?)
            ret.buttons[7]  = parseFloat(0).toFixed(2)
        else
            ret.buttons[7]  = rt
        ret.buttons[8]      = b[ 9].value
        ret.buttons[9]      = b[ 8].value
        ret.buttons[10]     = b[ 6].value
        ret.buttons[11]     = b[ 7].value
        ret.buttons[12]     = b[10].value
        ret.axes[0]         = b[14].value - b[13].value
        ret.axes[1]         = b[12].value - b[11].value
        ret.analog[0]       = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]       = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Firefox
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    __padsmethod.firefox_56e_2003 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]       = b[ 2].value
        ret.buttons[1]       = b[ 3].value
        ret.buttons[2]       = b[ 0].value
        ret.buttons[3]       = b[ 1].value
        ret.buttons[4]       = b[ 4].value
        ret.buttons[5]       = b[ 5].value
        ret.buttons[6]       = b[ 6].value
        ret.buttons[7]       = b[ 7].value
        ret.buttons[8]       = b[10].value
        ret.buttons[9]       = b[11].value
        ret.buttons[10]      = b[ 8].value
        ret.buttons[11]      = b[ 9].value
        ret.buttons[12]      = b[12].value
        ret.axes[0]          = b[16].value - b[15].value
        ret.axes[1]          = b[14].value - b[13].value
        ret.analog[0]        = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]        = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Chrome
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    __padsmethod.chrome_56e_2003 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]       = b[ 2].value
        ret.buttons[1]       = b[ 3].value
        ret.buttons[2]       = b[ 0].value
        ret.buttons[3]       = b[ 1].value
        ret.buttons[4]       = b[ 4].value
        ret.buttons[5]       = b[ 5].value
        ret.buttons[6]       = b[ 6].value
        ret.buttons[7]       = b[ 7].value
        ret.buttons[8]       = b[10].value
        ret.buttons[9]       = b[11].value
        ret.buttons[10]      = b[ 8].value
        ret.buttons[11]      = b[ 9].value
        ret.buttons[12]      = b[12].value
        if (a[9].toFixed(1) == "0.7")
            left = 1
        else
            left = 0
        if (a[9].toFixed(1) == "-0.4")
            right = 1
        else
            right = 0
        if (a[9].toFixed(1) == "-1.0")
            up = 1
        else
            up = 0
        if (a[9].toFixed(1) == "0.1")
            down = 1
        else
            down = 0
        ret.axes[0]               = right - left
        ret.axes[1]               = down - up
        ret.analog[0]             = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]             = [a[2].toFixed(2), a[5].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Safari
    # Controller :56e-2003-JC-U3613M - DirectInput Mode
    #============================================================================
    __padsmethod.safari_56e_2003 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]       = b[ 2].value
        ret.buttons[1]       = b[ 3].value
        ret.buttons[2]       = b[ 0].value
        ret.buttons[3]       = b[ 1].value
        ret.buttons[4]       = b[ 4].value
        ret.buttons[5]       = b[ 5].value
        ret.buttons[6]       = b[ 6].value
        ret.buttons[7]       = b[ 7].value
        ret.buttons[8]       = b[10].value
        ret.buttons[9]       = b[11].value
        ret.buttons[10]      = b[ 8].value
        ret.buttons[11]      = b[ 9].value
        ret.buttons[12]      = b[12].value
        if (a[9].toFixed(1) == "0.7")
            left = 1
        else
            left = 0
        if (a[9].toFixed(1) == "-0.4")
            right = 1
        else
            right = 0
        if (a[9].toFixed(1) == "-1.0")
            up = 1
        else
            up = 0
        if (a[9].toFixed(1) == "0.1")
            down = 1
        else
            down = 0
        ret.axes[0]               = right - left
        ret.axes[1]               = down - up
        ret.analog[0]             = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]             = [a[2].toFixed(2), a[5].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Firefox
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    __padsmethod.firefox_d9d_3013 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]        = b[ 0].value
        ret.buttons[1]        = b[ 1].value
        ret.buttons[2]        = b[ 2].value
        ret.buttons[3]        = b[ 3].value
        ret.buttons[4]        = b[ 4].value
        ret.buttons[5]        = b[ 6].value
        ret.buttons[6]        = b[ 5].value
        ret.buttons[7]        = b[ 7].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]    = 1
        else
            ret.buttons[8]    = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]    = 1
        else
            ret.buttons[9]    = 0
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]   = 1
        else
            ret.buttons[12]   = 0
        ret.axes[0]           = b[15].value - b[14].value
        ret.axes[1]           = b[13].value - b[12].value
        ret.analog[0]         = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]         = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Chrome
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    __padsmethod.chrome_d9d_3013 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]        = b[ 0].value
        ret.buttons[1]        = b[ 1].value
        ret.buttons[2]        = b[ 2].value
        ret.buttons[3]        = b[ 3].value
        ret.buttons[4]        = b[ 4].value
        ret.buttons[5]        = b[ 6].value
        ret.buttons[6]        = b[ 5].value
        ret.buttons[7]        = b[ 7].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]    = 1
        else
            ret.buttons[8]    = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]    = 1
        else
            ret.buttons[9]    = 0
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]   = 1
        else
            ret.buttons[12]   = 0
        a9 = a[9].toFixed(1)
        if (a9 == "0.4" || a9 == "0.7" || a9 == "1.0")
            left = 1
        else
            left = 0
        if (a9 == "-0.1" || a9 == "-0.4" || a9 == "-0.7")
            right = 1
        else
            right = 0
        if (a9 == "1.0" || a9 == "-1.0" || a9 == "-0.7")
            up = 1
        else
            up = 0
        if (a9 == "0.4" || a9 == "0.1" || a9 == "-0.1")
            down = 1
        else
            down = 0
        ret.axes[0]           = right - left
        ret.axes[1]           = down - up
        ret.analog[0]         = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]         = [a[2].toFixed(2), a[5].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Safari
    # Controller :d9d-3013-4Axes 12Key GamePad
    #============================================================================
    __padsmethod.safari_d9d_3013 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]        = b[ 0].value
        ret.buttons[1]        = b[ 1].value
        ret.buttons[2]        = b[ 2].value
        ret.buttons[3]        = b[ 3].value
        ret.buttons[4]        = b[ 4].value
        ret.buttons[5]        = b[ 6].value
        ret.buttons[6]        = b[ 5].value
        ret.buttons[7]        = b[ 7].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]    = 1
        else
            ret.buttons[8]    = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]    = 1
        else
            ret.buttons[9]    = 0
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]   = 1
        else
            ret.buttons[12]   = 0
        ret.axes[0]           = parseInt(a[2])
        ret.axes[1]           = parseInt(a[3])
        ret.analog[0]         = [a[2].toFixed(2), a[3].toFixed(2)]
        ret.analog[1]         = [a[1].toFixed(2), a[0].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Firefox
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    __padsmethod.firefox_1dd8_10 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]        = b[ 2].value
        ret.buttons[1]        = b[ 1].value
        ret.buttons[2]        = b[ 3].value
        ret.buttons[3]        = b[ 0].value
        ret.buttons[4]        = b[ 6].value
        ret.buttons[5]        = b[ 7].value
        ret.buttons[6]        = b[ 4].value
        ret.buttons[7]        = b[ 5].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]    = 1
        else
            ret.buttons[8]    = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]    = 1
        else
            ret.buttons[9]    = 0
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]   = 1
        else
            ret.buttons[12]   = 0
        ret.axes[0]           = b[16].value - b[15].value
        ret.axes[1]           = b[14].value - b[13].value
        ret.analog[0]         = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]         = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Chrome
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    __padsmethod.chrome_1dd8_10 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]        = b[ 2].value
        ret.buttons[1]        = b[ 1].value
        ret.buttons[2]        = b[ 3].value
        ret.buttons[3]        = b[ 0].value
        ret.buttons[4]        = b[ 6].value
        ret.buttons[5]        = b[ 7].value
        ret.buttons[6]        = b[ 4].value
        ret.buttons[7]        = b[ 5].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]    = 1
        else
            ret.buttons[8]    = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]    = 1
        else
            ret.buttons[9]    = 0
        ret.buttons[10]       = b[10].value
        ret.buttons[11]       = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]   = 1
        else
            ret.buttons[12]   = 0
        if (a[9].toFixed(1) == "0.7")
            left = 1
        else
            left = 0
        if (a[9].toFixed(1) == "-0.4")
            right = 1
        else
            right = 0
        if (a[9].toFixed(1) == "-1.0")
            up = 1
        else
            up = 0
        if (a[9].toFixed(1) == "0.1")
            down = 1
        else
            down = 0
        ret.axes[0]           = right - left
        ret.axes[1]           = down - up
        ret.analog[0]         = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]         = [a[2].toFixed(2), a[5].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :Safari
    # Controller :1dd8-10-iBUFFALO BSGP1204P Series
    #============================================================================
    __padsmethod.safari_1dd8_10 = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]            = b[ 2].value
        ret.buttons[1]            = b[ 1].value
        ret.buttons[2]            = b[ 3].value
        ret.buttons[3]            = b[ 0].value
        ret.buttons[4]            = b[ 6].value
        ret.buttons[5]            = b[ 7].value
        ret.buttons[6]            = b[ 4].value
        ret.buttons[7]            = b[ 5].value
        if (b[8].value && !b[9].value)
            ret.buttons[8]        = 1
        else
            ret.buttons[8]        = 0
        if (!b[8].value && b[9].value)
            ret.buttons[9]        = 1
        else
            ret.buttons[9]        = 0
        ret.buttons[10]           = b[10].value
        ret.buttons[11]           = b[11].value
        if (b[8].value && b[9].value)
            ret.buttons[12]       = 1
        else
            ret.buttons[12]       = 0
        ret.axes[0]               = parseInt(a[0])
        ret.axes[1]               = parseInt(a[1])
        ret.analog[0]             = [a[0].toFixed(2), a[1].toFixed(2)]
        ret.analog[1]             = [a[2].toFixed(2), a[3].toFixed(2)]

        return ret

    #============================================================================
    # Browser    :All
    # Controller :Generic
    #============================================================================
    generic_controller = (c)->
        ret = []
        ret.id = c.id
        ret.buttons = []
        ret.axes = [[], []]
        ret.analog = [[], []]

        a = c.axes
        b = c.buttons

        ret.buttons[0]            = b[ 1].value
        ret.buttons[1]            = b[ 0].value
        ret.buttons[2]            = b[ 2].value
        ret.buttons[3]            = b[ 3].value
        ret.buttons[4]            = b[ 4].value
        ret.buttons[5]            = b[ 5].value
        ret.buttons[6]            = 0
        ret.buttons[7]            = 0
        if (b[6].value && !b[7].value)
            ret.buttons[8]        = 1
        else
            ret.buttons[8]        = 0
        if (!b[6].value && b[7].value)
            ret.buttons[9]        = 1
        else
            ret.buttons[9]        = 0
        ret.buttons[10]           = 0
        ret.buttons[11]           = 0
        if (b[6].value && b[7].value)
            ret.buttons[12]       = 1
        else
            ret.buttons[12]       = 0
        ret.axes[0]               = parseInt(a[0])
        ret.axes[1]               = parseInt(a[1])
        ret.analog[0]             = 0
        ret.analog[1]             = 0

        return ret

