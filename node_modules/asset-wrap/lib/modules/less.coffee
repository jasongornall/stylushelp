
# dependencies
less = require 'less'
fs = require 'fs'
path = require 'path'
Asset = require('../asset').Asset

# asset
class exports.LessAsset extends Asset
  ext: 'css'
  name: 'less'
  type: 'text/css'
  compile: ->

    # defaults
    @config.paths ?= []

    # read source
    @read (err, source) =>
      return @emit 'error', err if err

      try

        # pre-process
        if @config.preprocess
          source = @config.preprocess source

        # compile
        parser = new less.Parser {
          optimization: 0
          silent: true
          color: true
          filename: @src
          paths: @config.paths.concat [path.dirname @src]
        }

      catch err
        return @emit 'error', err if err

      parser.parse source, (err, tree) =>
        return @emit 'error', err if err?

        try

          # minify
          result = tree.toCSS {
            compress: @config.compress or @config.minify
          }

          # post-process
          if @config.postprocess
            result = @config.postprocess result

        catch err
          return @emit 'error', err if err

        # complete
        @data = result
        @emit 'compiled'

