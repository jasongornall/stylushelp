express = require 'express'
wrap = require '../lib/index'

app = express()

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
], (err) ->
  throw err if err
  app.use assets.middleware

  app.get '/', (req, res) ->
    res.send """
      <head>
        #{assets.tag '/css/hello.css'}
        #{assets.tag '/js/hello.js'}
      </head>
      <body>
        <a href="#{assets.url '/css/hello.css'}">View CSS</a>
        <pre>#{assets.data '/css/hello.css'}</pre>
        <a href="#{assets.url '/js/hello.js'}">View Javascript</a>
        <pre>#{assets.data '/js/hello.js'}</pre>
      </body>
    """
  app.listen 3000

