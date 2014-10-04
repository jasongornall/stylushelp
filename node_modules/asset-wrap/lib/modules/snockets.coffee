
# dependencies
chokidar = require 'chokidar'
path = require('path')
Snockets = require 'snockets'
Asset = require('../asset').Asset

# asset
class exports.SnocketsAsset extends Asset
  ext: 'js'
  name: 'snockets'
  type: 'text/javascript'
  constructor: (@config, callback) ->
    super @config, callback
    @snockets = new Snockets()

  compile: ->

    # defaults
    @config.minify = @config.minify or @config.compress

    # read source, compile, minify
    @snockets.getConcatenation @src, {
      async: false
      minify: @config.minify
    }, (err, result) =>
      return @emit 'error', err if err
      
      try

        # post-process
        if @config.postprocess
          result = @config.postprocess result

      catch err
        return @emit 'error', err if err

      # complete
      @data = result
      @emit 'compiled'

  watch: ->
    @snockets.scan @src, (err, graph) =>
      for file in graph.getChain @src
        watcher = chokidar.watch file, {ignored: /^\./, persistent: false}
        watcher.on 'change', (path, stats) =>
          console.log "asset.wrap[snockets] file changed: #{path}"
          @compile()
