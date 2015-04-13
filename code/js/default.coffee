###
HeatColor, by Josh Nathanson
A plugin for jQuery
See copyright at end of file
Complete documentation at http://www.jnathanson.com/blog/client/jquery/heatcolor/index.cfm
###

jQuery.fn.heatcolor = (valueFunction, options) ->
  settings = 
    elementFunction: ->
      jQuery this
    minval: 0
    maxval: 0
    lightness: 0.75
    colorStyle: 'roygbiv'
    reverseOrder: false

  if options
    jQuery.extend settings, options

  # helper functions
  helpers = 
    findcolor: (curval, mn, mx) ->
      # value between 1 and 0
      position = (curval - mn) / (mx - mn)
      # this adds 0.5 at the top to get red, and limits the bottom at x= 1.7 to get purple
      shft = if settings.colorStyle == 'roygbiv' then 0.5 * position + 1.7 * (1 - position) else position + 0.2 + 5.5 * (1 - position)
      # scale will be multiplied by the cos(x) + 1 
      # (value from 0 to 2) so it comes up to a max of 255
      scale = 96
      # period is 2Pi
      period = 2 * Math.PI
      # x is place along x axis of cosine wave
      x = shft + position * period
      # shift to negative if greentored
      x = if settings.colorStyle != 'roygbiv' then -x else x
      r = @process(Math.floor((Math.cos(x) + 1) * scale))
      g = @process(Math.floor((Math.cos(x + Math.PI / 2) + 1) * scale))
      b = @process(Math.floor((Math.cos(x + Math.PI) + 1) * scale))
      "##{r}#{g}#{b}"

    process: (num) ->
      # adjust lightness
      n = Math.floor(num + settings.lightness * (256 - num))
      # turn to hex
      s = n.toString(16)
      # if no first char, prepend 0
      if s.length == 1 then '0' + s else s
      
    setMaxAndMin: (els) ->
      vals = []
      els.each ->
        vals.push valueFunction.apply(jQuery(this))
        return
      vals = vals.sort((a, b) ->
        a - b
      )
      settings.maxval = if !settings.reverseOrder then vals[vals.length - 1] else vals[0]
      settings.minval = if !settings.reverseOrder then vals[0] else vals[vals.length - 1]
      return
  # close helper functions
  if !settings.minval and !settings.maxval
    helpers.setMaxAndMin jQuery(this)
  else if settings.reverseOrder
    temp = settings.minval
    settings.minval = settings.maxval
    settings.maxval = temp
  jQuery(this).each ->
    # iterate over jQuery object (array of elements)
    el = jQuery(this)
    # current element
    # get the value to find in range
    curval = valueFunction.apply(el)
    # get current color
    curcolor = helpers.findcolor(curval, settings.minval, settings.maxval)
    # find the element to color
    elToColor = settings.elementFunction.apply(el)
    # color it
    if elToColor[0].nodeType == 1
      elToColor.addClass 'widget-formatter'
      elToColor.css 'background-color', curcolor
      #console.log settings, curval, curcolor
    else if elToColor[0].nodeType == 3
      elToColor.css 'color', curcolor
  this
