express = require 'express'
wrap = require '../lib/index'

app = express()

app.get '/css/hello.css', (req, res) ->
  asset = new wrap.Stylus {
    src: 'assets/hello.styl'
    compress: true
  }, (err) ->
    return res.send 500, err if err
    res.setHeader 'Content-Type', asset.type
    res.send asset.data

app.get '/js/hello.js', (req, res) ->
  asset = new wrap.Snockets {
    src: 'assets/hello.coffee'
    compress: true
  }, (err) ->
    return res.send 500, err if err
    res.setHeader 'Content-Type', asset.type
    res.send asset.data

app.get '/js/not-found.js', (req, res) ->
  asset = new wrap.Snockets {
    src: 'assets/not-found.coffee'
    compress: true
  }, (err) ->
    return res.send 500, err if err
    res.setHeader 'Content-Type', asset.type
    res.send asset.data

app.get '/', (req, res) ->
  res.send """
    <body>
      <div><a href="/css/hello.css">View CSS</a></div>
      <div><a href="/js/hello.js">View Javascript</a></div>
      <div><a href="/js/not-found.js">View Javascript Error</a></div>
    </body>
  """

app.listen 3000
