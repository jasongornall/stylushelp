wrap = require '../lib/index'

assets = new wrap.Assets [
  new wrap.Snockets {
    src: 'assets/hello.coffee'
    compress: true
  }
  new wrap.Snockets {
    src: 'assets/goodbye.coffee'
    compress: true
  }
], (err) ->
  throw err if err
  asset = assets.merge()
  console.log asset.data

