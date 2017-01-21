proc = (gamepad)->
    gamepad.stat()
    str = ""
    for c in gamepad.controllers
        if (c?)
            str += "<font style='font-weight:bold; font-size:24pt;'>"+c.id+"</font><br>"
            str += "Buttons<br>"
            str += "<font style='font-weight:bold; font-size:14pt;'>"
            for buttons, val of c.buttons
                str += buttons+"=["+val+"]<br>"
            str += "</font>"
            str += "Analog<br>"
            str += "<font style='font-weight:bold; font-size:14pt;'>"
            for analog, val of c.analog
                str += analog+"=["+val+"]<br>"
            str += "</font>"
            str += "Axes<br>"
            str += "<font style='font-weight:bold; font-size:14pt;'>"
            for axes, val of c.axes
                str += axes+"=["+val+"]<br>"
            str += "</font><hr>"
    $("#main").html(str)
    window.requestAnimationFrame(proc.bind(null, gamepad))

$ ->
    bounds = getBounds()
    width = bounds.size.width
    height = bounds.size.height

    gamepad = new enforceGamepad()
    proc(gamepad)
