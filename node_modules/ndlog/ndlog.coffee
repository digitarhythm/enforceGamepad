#==============================================================================
#
# NDLog - Console log module like NSLog on iOS
#
# 2017.07.12 Coded by Hajime Oh-yake
#
#==============================================================================

class NDLog

  #==========================================================================
  # Display value when debug
  #==========================================================================
  echo:(a, b...) ->
    if (typeof a == 'object')
      console.table(a) if (process.env.NODE_ENV == "develop")
    else
      console.log(_sprintf(a, b...)) if (process.env.NODE_ENV == "develop")

  #==========================================================================
  # format string
  #==========================================================================
  form:(a, b...) ->
    return(_sprintf(a, b...))

  #==========================================================================
  # format string (static method)
  #==========================================================================
  _sprintf = (a, b...) ->
    for data in b
      match = a.match(/%0\d*@/)
      if (match?)
        repstr = match[0]
        num = parseInt(repstr.match(/\d+/))
        zero =""
        zero += "0" while (zero.length < num)
        data2 = (zero+data).substr(-num)
        a = a.replace(repstr, data2)
      else
        a = a.replace('%@', data)
    return a

module.exports = new NDLog()

