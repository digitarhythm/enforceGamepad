fs     = require 'fs-extra'
coffee = require 'coffeescript'

module.exports = compiler =
  fromSource: (src, opts..., callback) ->
    opts = opts[0] or {}

    try
      results = coffee.compile src, opts

      if results.charAt?
        code = results
      else
        {js: code, v3SourceMap} = results

        if v3SourceMap
          map = JSON.parse v3SourceMap
          map.sources = [opts.filename]
          map.sourcesContent = [src]

          code += '\n//@ sourceMappingURL=data:application/json;base64,'
          code += new Buffer(JSON.stringify map).toString('base64')
    catch err
      if err.name is 'SyntaxError'
        err.message = err.toString()

    callback err, code

  fromFile: (filepath, opts..., callback) ->
    opts = opts[0] or {}
    opts.filename ?= filepath

    fs.readFile filepath, 'utf8', (err, src) ->
      return callback err if err?
      compiler.fromSource src, opts, callback
