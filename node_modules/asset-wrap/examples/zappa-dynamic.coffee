require('zappajs') ->
  wrap = require '../lib/index'

  @get '/css/hello.css': ->
    asset = new wrap.Stylus {
      src: 'assets/hello.styl'
      compress: true
    }, (err) =>
      return @res.send 500, err if err
      @res.setHeader 'Content-Type', asset.type
      @res.send asset.data
 
  @get '/js/hello.js': ->
    asset = new wrap.Snockets {
      src: 'assets/hello.coffee'
      compress: true
    }, (err) =>
      return @res.send 500, err if err
      @res.setHeader 'Content-Type', asset.type
      @res.send asset.data

  @get '/js/not-found.js': ->
    asset = new wrap.Snockets {
      src: 'assets/not-found.coffee'
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
        a href: '/css/hello.css', ->
          'View CSS'
      div ->
        a href: '/js/hello.js', ->
          'View Javascript'
      div ->
        a href: '/js/not-found.js', ->
          'View Javascript Error'

