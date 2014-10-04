wrap = require '../lib/index'

cdn =
  provider: 'rackspace'
  username: 'YOUR_USERNAME'
  apiKey: 'YOUR_API_KEY'
  container: 'media'
  cname: 'http://YOUR_CNAME.com'

asset = new wrap.Snockets {
  src: 'assets/hello.coffee'
  compress: true
  cdn: cdn
  dst: 'assets/test.js'
}, (err) ->
  throw err if err
  console.log asset.url

  assets = new wrap.Assets [
    new wrap.Snockets {
      src: 'assets/hello.coffee'
    }
    new wrap.Snockets {
      src: 'assets/goodbye.coffee'
    }
  ], {
    compress: false#true
    cdn: cdn
    dst: 'assets/merge-test.js'
  }, (err) ->
    throw err if err
    asset = assets.merge ->
      console.log asset.url

