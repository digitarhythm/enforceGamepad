#=============================================================================
#
# enforceGamePad Library
#
#=============================================================================

class enforceGamePad
  constructor:(param)->
    lang = (window.navigator.languages && window.navigator.languages[0]) ||
                window.navigator.language ||
                window.navigator.userLanguage ||
                window.navigator.browserLanguage
    match = lang.match(/^(..)-.*$/)
    if (match? && match.length > 1)
      @LANGUAGE = match[1]
    else
      @LANGUAGE = lang

    @ASSETS = {}
    @ASSETS["en"] =
      "CLOSE": "Close"
    @ASSETS["ja"] =
      "CLOSE": "閉じる"

    ###
    @controllers = []

    @buttonlist = []
    @analog = []
    @axes = []
    @pushbutton = []

    @targetbutton = 0

    @bindmode = 0
    @button_num = 13
    ###

  #==================================
  #==================================
  viewDidLoad:->
    super()

    ###
    y = 32
    @startbutton = new UIButton(FWRectMake(
      32
      y
      120
      32
    ))
    @startbutton.title = "スタート"
    @addSubview(@startbutton)
    @startbutton.addTarget =>
      if (@bindmode == 0)
        for i in [0...@buttonlist.length]
          @buttonlist[i].text = ""
          @buttonlist[i].backgroundColor = FWColor(255, 255, 255, 1.0)
        @pushbutton = []
        @bindmode = 1
        @startbutton.title = "ストップ"
        @buttonlist[@targetbutton].backgroundColor = FWColor(255, 0, 0, 1.0)
      else
        @stop()
        @startbutton.title = "開始"

    y += (@startbutton.frame.size.height + 4)

    @skipbutton = new UIButton(FWRectMake(
      32
      y
      120
      32
    ))
    @skipbutton.title = "スキップ"
    @addSubview(@skipbutton)
    @skipbutton.addTarget =>
      @next()

    y += (@skipbutton.frame.size.height + 4)

    for i in [0...@button_num]
      text = new UITextLabel(FWRectMake(
        32
        y+(32*i)
        120
        32
      ))
      text.borderWidth = 0.0
      text.textAlign = "UITextAlignmentRight"
      text.text = "Button #{i}"
      @addSubview(text)

      btn = new UITextLabel(FWRectMake(
        48+text.frame.size.width
        y+(32*i)
        120
        32
      ))
      btn.font.color = FWColor(0, 0, 0, 1.0)
      btn.borderWidth = 1.0
      btn.textAlign = "UITextAlignmentLeft"
      btn.text = ""
      @addSubview(btn)
      @buttonlist.push(btn)
    ###


  #==================================
  #==================================
  viewDidAppear:->
    super()

  #==================================
  #==================================
  viewWillDisappear:->
    super()

  #==================================
  #==================================
  setStyle:(key=undefined)->
    super(key)

  #==================================
  #==================================
  #didBrowserResize:(bounds)->
  #   super()

  #==================================
  #==================================
  #didWindowsResize:->
  #   super()

  #==================================
  #==================================
  behavior:->
    super()
    ###
    gamepads = if (navigator.getGamepads) then navigator.getGamepads() else (if (navigator.webkitGetGamepads) then navigator.webkitGetGamepads() else [])
    if (gamepads[0]?)
      buttons = gamepads[0].buttons

      switch @bindmode
        when 1
          @push = -1

          for i in [0...@buttonlist.length]
            @buttonlist[@targetbutton].backgroundColor = FWColor(255, 0, 0, 1.0)
            if (!buttons[i]?)
              continue
            if (buttons[i].pressed)
              @push = i
              break

          if (@push >= 0)
            @bindmode = 2
            @next(@push)

        when 2
          if (!buttons[@push].pressed)
            @bindmode = 1
    ###

  next:(push = undefined)->
    if (!push? || @pushbutton.indexOf(push) < 0)
      @pushbutton[@targetbutton] = push
      @buttonlist[@targetbutton].text = push
      @buttonlist[@targetbutton].backgroundColor = FWColor(255, 255, 255, 1.0)
      @targetbutton++
      if (@targetbutton == @button_num)
        @stop()

  stop:->
    @bindmode = 0
    @startbutton.title = "開始"
    @targetbutton = 0


  beginSetup:->
    bounds = {}
    bounds.width = parseInt(window.innerWidth)
    bounds.height = parseInt(window.innerHeight)

    @coverview = document.createElement("div")
    @coverview.style.position = "absolute"
    @coverview.style.width = "#{bounds.width}px"
    @coverview.style.height = "#{bounds.height}px"
    @coverview.style.left = "0px"
    @coverview.style.top = "0px"
    @coverview.style.opacity = 0.0
    @coverview.style.backgroundColor = "rgba(0, 0, 0, 0.8)"
    @coverview.style.zIndex = "1000"
    document.body.appendChild(@coverview)

    buttonsize = {}
    buttonsize.width = parseInt(bounds.width / 8.0)
    buttonsize.height = parseInt(bounds.height / 20.0)

    @closebutton = document.createElement("div")
    @closebutton.style.position = "absolute"
    @closebutton.style.width = parseInt(buttonsize.width)+"px"
    @closebutton.style.height = parseInt(buttonsize.height)+"px"
    @closebutton.style.left = parseInt((bounds.width - buttonsize.width) / 2.0)+"px"
    @closebutton.style.top = parseInt(bounds.height - (buttonsize.height + 8.0))+"px"
    @closebutton.style.backgroundColor = "rgba(10, 10, 10, 0.8)"
    @closebutton.style.border = "1px #ffffff solid"
    @closebutton.style.color = "#f0f0f0"
    @closebutton.style.textAlign = "center"
    @closebutton.style.lineHeight = buttonsize.height+"px"
    @closebutton.style.fontSize = "16pt"
    @closebutton.style.fontWeight = "bold"
    @closebutton.style.borderRadius = "8.0px"
    @closebutton.style.cursor = "pointer"
    @closebutton.style.filter = "drop-shadow(2px 2px 4px rgba(255, 255, 255, 0.6))"
    @coverview.appendChild(@closebutton)
    @closebutton.innerText = @ASSETS[@LANGUAGE]["CLOSE"]

    touchsupport = 'ontouchend' in document
    TOUCHEND_EVENT = if (touchsupport) then 'touchend' else 'mouseup'
    @closebutton.addEventListener TOUCHEND_EVENT, (e)=>
      animation = @coverview.animate [
        {opacity: 1.0}
        {opacity: 0.0}
      ], 100
      animation.onfinish = =>
        @coverview.remove()

    controllersize = {}
    controllersize.width = parseInt(bounds.width / 2)
    controllersize.height = parseInt(bounds.height / 2)
    controllerorigin = {}
    controllerorigin.left = parseInt((bounds.width - controllersize.width) / 2.0)+"px"
    controllerorigin.top = parseInt((bounds.height - controllersize.height) / 2.0)+"px"

    controller_image = new Image()
    controller_image.src = "/public/gamecontroller.png"
    controller_image.onload = =>
      ctx = @gamecontroller.getContext('2d')
      ctx.drawImage(controller_image, controllerorigin.left, controllerorigin.top, controllersize.width, controllersize.height)
      animation = @coverview.animate [
        {opacity: 0.0}
        {opacity: 1.0}
      ], 100
      animation.onfinish = =>
      @coverview.style.opacity = 1.0

    @gamecontroller = document.createElement("canvas")
    @gamecontroller.style.position = "absolute"
    @gamecontroller.style.width = "#{controllersize.width}px"
    @gamecontroller.style.height = "#{controllersize.height}px"
    @gamecontroller.style.left = parseInt((bounds.width - controllersize.width) / 2)
    @gamecontroller.style.top = parseInt((bounds.height - controllersize.height) / 2)
    @gamecontroller.style.filter = "drop-shadow(2px 2px 4px rgba(255, 255, 255, 0.6))"
    @gamecontroller.style.backgroundColor = "rgba(0, 127, 255, 1.0)"
    @coverview.appendChild(@gamecontroller)



  #==================================
  #==================================
  #touchesBegan:(pos, e)->
  #   super()

  #==================================
  #==================================
  #touchesMoved:(pos, e)->
  #   super()

  #==================================
  #==================================
  #touchesEnded:(pos, e)->
  #   super()

  #==================================
  #==================================
  #touchesCanceled:(pos, e)->
  #   super()
