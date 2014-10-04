cluster = require 'cluster'
os      = require 'os'

if cluster.isMaster
  # Fork workers
  cluster.fork() for i in os.cpus()
  cluster.on 'exit', (worker, code, signal) ->
    console.log "worker #{worker.process.pid} died"
else
  # Workers can share any TCP connection
  require('zappajs') ->
    wrap = require '../lib/index'
    assets = new wrap.Assets [
      new wrap.Snockets {
        src: 'assets/hello.coffee'
        dst: '/js/hello.js'
        compress: true
      }
    ], (err) =>
      throw err if err
      @use assets.middleware

      @get '/': ->
        @render index: {
          assets: assets
        }

      @view index: ->
        body ->
          a href: @assets.url '/js/hello.js', ->
            'View Javascript'
          pre ->
            @assets.data '/js/hello.js'

