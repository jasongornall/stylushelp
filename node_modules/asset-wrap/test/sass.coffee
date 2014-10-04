wrap = require '../lib/index'

describe 'Sass', ->

  it 'should wrap correctly without shortcut', (done) ->
    asset = new wrap.Sass {
      src: "#{__dirname}/assets/hello.sass"
    }
    asset.on 'error', (err) ->
      throw err
    asset.on 'complete', ->
      asset.md5.should.equal '2228e977ebea8966e27929f43e39cb67'
      done()
    asset.wrap()

  it 'should wrap correctly', (done) ->
    asset = new wrap.Sass {
      src: "#{__dirname}/assets/hello.sass"
    }, (err) ->
      throw err if err
      asset.md5.should.equal '2228e977ebea8966e27929f43e39cb67'
      done()

