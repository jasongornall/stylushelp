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

    @get '/js/hello.js': ->
      asset = new wrap.Snockets {
        src: 'assets/hello.coffee'
        compress: true
      }, (err) =>
        return @res.send 500, err if err
        @res.setHeader 'Content-Type', asset.type
        @res.send asset.data

    @get '/': ->
      @render 'index': {layout: no}

    @view index: ->
      body ->
        div ->
          a href: '/js/hello.js', ->
            'View Javascript'

