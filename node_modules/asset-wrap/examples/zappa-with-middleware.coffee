require('zappajs') ->
  wrap = require '../lib/index'
  assets = new wrap.Assets [
    new wrap.Snockets {
      src: 'assets/hello.coffee'
      dst: '/js/hello.js'
      compress: true
    }
    new wrap.Stylus {
      src: 'assets/hello.styl'
      dst: '/css/hello.css'
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
      head ->
        text @assets.tag '/css/hello.css'
        text @assets.tag '/js/hello.js'
      body ->
        a href: @assets.url '/css/hello.css', ->
          'View CSS'
        pre ->
          @assets.data '/css/hello.css'
        a href: @assets.url '/js/hello.js', ->
          'View Javascript'
        pre ->
          @assets.data '/js/hello.js'

