require('zappajs') ->
  wrap = require '../lib/index'

  @get '/css/compress.css': ->
    asset = new wrap.Stylus {
      src: 'assets/compress.styl'
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
        a href: '/css/compress.css', ->
          'View CSS'

