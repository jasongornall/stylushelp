
# dependencies
coffee = require 'coffee-script'
fs = require 'fs'
path = require 'path'
Asset = require('../asset').Asset
UglifyJS = require 'uglify-js'

# asset
class exports.CoffeeAsset extends Asset
  ext: 'js'
  name: 'coffee'
  type: 'text/javascript'
  compile: ->

    # defaults
    @config.minify = @config.compress or @config.minify

    # read source
    @read (err, source) =>
      return @emit 'error', err if err
      
      try

        # pre-process
        if @config.preprocess
          source = @config.preprocess source

        # compile
        result = coffee.compile source

        # post-process
        if @config.postprocess
          result = @config.postprocess result

        # minify
        if @config.minify
          result = UglifyJS.minify(result, {
            fromString: true
            mangle: true
          }).code

      catch err
        return @emit 'error', err if err

      # complete
      @data = result
      @emit 'compiled'

