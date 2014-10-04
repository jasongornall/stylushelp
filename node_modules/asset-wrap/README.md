Asset-Wrap is a simple asset manager for node.

## Goals
1. build anytime (middleware or dynamically)
2. css: support stylus, less, and sass
3. js: support coffee-script
4. use async whenever possible
5. support cluster
6. easily extendible
7. watch for file changes
8. serve files from s3 or cloudfiles or azure

## Install
```bash
npm install asset-wrap
```

## Asset
An asset representing a css or js file

```
asset = new wrap.Asset {
  src: '/js/app.js'
}
```

### Options
* `cache`: maxAge to set cache headers
* `src`: the path to your source file
* `dst`: the location to serve your file from (without the md5 appended)
* `url`: the dst with the md5 appended
* `cdn`: cdn information to push assets to
* `data`: the content
* `ext`: the file extension of the wrapped asset
* `md5`: the md5 of the wrapped content
* `tag`: the full html tag to render

### Events
* `complete`: Emitted after asset has content, headers, url, etc. 
* `compiled`: Emitted once asset.data is compiled
* `error`: Emitted if there is an error compiling the asset

### Creating a Custom Asset
```
class MyAsset extends wrap.Asset
  ext: 'txt'
  name: 'my-asset'
  type: 'text/plain'
  compile: ->
    @data = 'hello world'
    @emit 'compiled'

```
## Assets
A group of `Asset`s. Use when you're compiling multiple assets or for middleware

```
assets = new wrap.Assets [
  new wrap.Snockets {
    src: 'assets/hello.coffee'
  }
  new wrap.Stylus {
    src: 'assets/hello.styl'
  }
], {
  compress: true
  watch: true
}, (err) =>
  throw err if err
```

### Options
Options are the exact same as an asset. Any options given here are passed
down to each asset.

## Asset Types
* CSSAsset
* LessAsset
* SassAsset
* SnocketsAsset
* StylusAsset


## Examples
### Use as Middleware with ZappaJS
```
require('zappajs') ->
  wrap = require 'asset-wrap'
  assets = new wrap.Assets [
    new wrap.Snockets {
      src: 'assets/hello.coffee'
      dst: '/js/hello.js'
    }
    new wrap.Stylus {
      src: 'assets/hello.styl'
      dst: '/css/hello.css'
    }
  ], {
    compress: true
    watch: true
  }, (err) =>
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
```

### Generate Asset Dynamically in ZappaJS
```
require('zappajs') ->
  wrap = require 'asset-wrap'

  @get '/': ->
    asset = new wrap.Snockets {
      src: 'assets/hello.coffee'
      compress: true
    }, (err) =>
      @res.send 500, err if err
      @res.setHeader 'ContentType', asset.type
      @res.send asset.data
```

### Generate Asset Dynamically With Cluster
```
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
    wrap = require 'asset-wrap'

    @get '/js/hello.js': ->
      asset = new wrap.Snockets {
        src: 'assets/hello.coffee'
        dst: '/js/hello.js'
        compress: true
      }, (err) =>
        @res.send 500, err if err
        @res.setHeader 'ContentType', asset.type
        @res.send asset.data

    @get '/': ->
      @render 'index': {layout: no}

    @view index: ->
      body ->
        div ->
          a href: '/js/hello.js', ->
            'View Javascript'
```

# Credit
Much inspiration from the other asset management tools out there.
* Brad Carleton's [asset-rack](https://github.com/techpines/asset-rack)
* Trevor Burnham's [connect-assets](https://github.com/TrevorBurnham/connect-assets)
* the [Rails Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html)

# License
©2013 Bryant Williams under the [MIT license](http://www.opensource.org/licenses/mit-license.php):

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
