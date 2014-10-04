
# dependencies
fs = require 'fs'
path = require 'path'
Asset = require('../asset').Asset
CleanCSS = require 'clean-css'

# asset
class exports.CSSAsset extends Asset
  ext: 'css'
  name: 'css'
  type: 'text/css'
  compile: ->

    # defaults
    @config.minify = @config.minify or @config.compress or @config.cleancss

    # read source
    @read (err, source) =>
      return @emit 'error', err if err

      try

        # pre-process
        if @config.preprocess
          source = @config.preprocess

        # compile
        result = source

        # post-process
        if @config.postprocess
          result = @config.postprocess result

        # minify
        if @config.minify
          result = new CleanCSS({}).minify result

      catch err
        return @emit 'error', err if err

      # complete
      @data = result
      @emit 'compiled'

